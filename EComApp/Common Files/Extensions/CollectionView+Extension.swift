//
//  CollectionView+Extension.swift
//  EComApp
//
//  Created by Raj Kadam on 05/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

extension UICollectionView {
    func scrollToTop() {
           self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
       }
}
