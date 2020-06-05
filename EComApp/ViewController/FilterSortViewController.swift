//
//  FilterSortViewController.swift
//  EComApp
//
//  Created by Raj Kadam on 03/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class FilterSortViewController: UIViewController {
    
    weak var delegate: ProductListProtocol?
    @IBOutlet weak private var subCategoryTableView: UITableView!
    @IBOutlet weak private var categoryTableView: UITableView!
    
    fileprivate let categoryCellIdentifier = "CategoryTableViewCell"
    fileprivate let subcategoryCellIdentifier = "SubCategoryTableViewCell"
    
    fileprivate var categoryList: [Category] = []
    fileprivate var subcategoryList: [Category] = []
    var selectedCategories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerNibs()
        
        if let fetchData = self.fetchCategoryDataFromDatabase() {
            self.categoryList = fetchData
            categoryTableView.reloadData()
        }
    }
    
    // MARK: - fetchCategories Method
       /**
        This method fetch the categories from local DB
       
        */
    
    fileprivate func fetchCategoryDataFromDatabase() -> [Category]? {
        
        let predicate = NSPredicate(format: "self.parentCategoryId == -1")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let fetchData = try? CoreDataManager.fetch(predicate: predicate, sortDescriptor: sortDescriptor, entity: "Category") as? [Category]
        
        return fetchData
    }
  
    // MARK: - Register Nib Method
    /**
     This method  registers required cell with UITableView
     */
    func registerNibs() {
        
        categoryTableView.register(UINib.init(nibName: categoryCellIdentifier, bundle: nil), forCellReuseIdentifier: categoryCellIdentifier)
        
        subCategoryTableView.register(UINib.init(nibName: subcategoryCellIdentifier, bundle: nil), forCellReuseIdentifier: subcategoryCellIdentifier)
    }
    
    // MARK: - Apply Filter Method
    /**
     This method  creates categoryViewModel and send it back to Product list View
     */
    @IBAction func applyAction(_ sender: UIButton) {
        let selectedCategoryVM = SelectedCategoryViewModel(selectedCategories: selectedCategories)
        delegate?.filterProducts(selecteCategoryViewModel: selectedCategoryVM)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Reset Filter Method
    /**
     This method  reset applied filter
     */
    @IBAction func resetAction(_ sender: UIButton) {
        
       let selectedCategoryVM = SelectedCategoryViewModel(selectedCategories: [Category]())
        delegate?.filterProducts(selecteCategoryViewModel: selectedCategoryVM)
        self.navigationController?.popViewController(animated: true)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - TableView Delegate , Datasource Extension
/**
    fetch data from local DB and
    Set category and subcategory cells accordingly
 */
extension FilterSortViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == categoryTableView {
            return categoryList.count
        } else {
            return subcategoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == categoryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryTableViewCell
            
            let categoryViewModel = CategoryViewModel(categoryList[indexPath.item])
            cell.setupCellData(categoryVM: categoryViewModel)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: subcategoryCellIdentifier, for: indexPath) as! SubCategoryTableViewCell
            let selectedCategoryViewModel = SelectedCategoryViewModel(selectedCategories: selectedCategories)
            let categoryViewModel = CategoryViewModel(subcategoryList[indexPath.item])
            cell.setupCellData(categoryVM: categoryViewModel, selectedCategoryVM: selectedCategoryViewModel)
            return cell
        }
        
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTableView {
            let selectedCategory = categoryList[indexPath.row]
            
            if let childCategories = selectedCategory.childCategories, childCategories.count > 0 {
                
                subcategoryList = getCategoryList(categoryList: childCategories)
                subCategoryTableView.reloadData()
                
            }
        } else {
            let visibleCategory = subcategoryList[indexPath.row]
            
            if let childCategories = visibleCategory.childCategories, childCategories.count > 0 {
                subcategoryList = getCategoryList(categoryList: childCategories)
                subCategoryTableView.reloadData()
                
            } else {
                
                    if let index = selectedCategories.firstIndex(of: visibleCategory) {
                        selectedCategories.remove(at: index)
                        self.subCategoryTableView.reloadData()
                        return
                    }
                
                selectedCategories.appendIfNotContains(visibleCategory)
                self.subCategoryTableView.reloadData()
                
            }
        }
    }
    
    // MARK: - Category List Method
    /**
     This method returns the subcategories according to input category list
     */
func getCategoryList(categoryList: [Int]) -> [Category] {
        
        let predicate = NSPredicate(format: "ANY self.id in %@", categoryList)
        
        guard let categoryList = try? CoreDataManager.fetch(predicate: predicate, sortDescriptor: nil, entity: "Category") as? [Category], categoryList.count > 0 else {
            fatalError("No subcategory found")
        }
        
            return categoryList
    }
}
