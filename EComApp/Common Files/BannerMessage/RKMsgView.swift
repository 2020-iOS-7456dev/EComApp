//
//  RKMsgView.swift
//  Collab
//
//  Created by Raj Kadam on 03/08/18.
//  Copyright © 2018 Raj K. All rights reserved.
//

import Foundation
import UIKit

public class RKMsgViewConfig {
    ///Set delay to hide AlertView. Default: 2.0.
    public var delay: TimeInterval = 2.0
    ///Set duration of AlertView visible animation. Default: 0.3.
    public var duration: TimeInterval = 0.3
    ///Set AlertView message color. Default: white.
    public var messageColor: UIColor = UIColor.white
    ///Set AlertView message font. Default: UIFont.systemFont(ofSize: 12).
    public var messageFont: UIFont = UIFont.systemFont(ofSize: 12)
    ///Set AlertView message icon. Default: Empty UIImage.
    public var messageIcon: UIImage! = UIImage.init()
    ///Set AlertView background color. Default: red.
    public var backgroundColor: UIColor = UIColor.red
}

public class RKMsgView: UIView {
    
    typealias CompletionBlock = () -> Void
    
    fileprivate var isAlertShowing: Bool = false
    fileprivate var delay: TimeInterval
    fileprivate var duration: TimeInterval
    fileprivate var completion: CompletionBlock?
    
    fileprivate var messageButton: UIButton = UIButton.init(type: .custom)
    fileprivate var messageColor: UIColor = UIColor.white
    fileprivate var messageFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    fileprivate let heightForAlertView: CGFloat = 30.0
    
    fileprivate var yPosForAlertView: CGFloat {
        if let navigationController = ((UIApplication.shared.keyWindow?.rootViewController) as? UINavigationController) {
            return ((navigationController.navigationBar.intrinsicContentSize.height)
                + UIApplication.shared.statusBarFrame.height)
        }
        return 0.0
    }
    
    fileprivate var unhideYPositionForAlertView: CGFloat {
        get {
            let yPos = self.yPosForAlertView
            return yPos
        }
    }
    
    fileprivate var hiddenYPositionForAlertView: CGFloat {
        get {
            let yPos = self.yPosForAlertView
            return yPos
        }
    }
    
    public init(duration: TimeInterval = 0.3, delay: TimeInterval = 2.0) {
        
        self.completion = nil
        self.delay = delay
        self.duration = duration
        
        super.init(frame: CGRect.zero)
        
        self.setupAlertView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIViewController Extension
public extension UIViewController {
    
    func rk_msgAlert(message: String!, withConfig config: RKMsgViewConfig!) {
        RKMsgView(duration: config.duration, delay: config.delay)
            .backgroundColor(color: config.backgroundColor)
            .message(message: message)
            .messageIcon(icon: config.messageIcon)
            .messageColor(color: config.messageColor)
            .messageFont(font: config.messageFont)
            .show()
    }
    
    ///Show RK_viewAlert with default config.
    func rk_msgAlert(message: String!) {
        let config = RKMsgViewConfig()
        RKMsgView(duration: config.duration, delay: config.delay)
            .backgroundColor(color: config.backgroundColor)
            .message(message: message)
            .messageIcon(icon: config.messageIcon)
            .messageColor(color: config.messageColor)
            .messageFont(font: config.messageFont)
            .show()
    }
}

// MARK: setup function
extension RKMsgView {
    
    fileprivate func setupAlertView() {
        self.setupView()
        
        self.setupMessageButton()
    }
    
    fileprivate func setupView() {
        self.backgroundColor = UIColor.backgroundColor
        self.frame = CGRect(x: 0, y: self.hiddenYPositionForAlertView, width: UIScreen.main.bounds.width, height: heightForAlertView)
    }
    
    fileprivate func setupMessageButton() {
        self.messageButton.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.messageButton.setTitleColor(self.messageColor, for: .normal)
        self.messageButton.titleLabel?.font = self.messageFont
        self.messageButton.backgroundColor = UIColor.clear
        self.messageButton.setTitle("", for: .normal)
        self.messageButton.contentVerticalAlignment = .center
        self.messageButton.contentHorizontalAlignment = .center
        self.addSubview(self.messageButton)
        self.messageButton.centerTextAndImage(spacing: 5.0)
    }
}

// MARK: chaning function and show / hide functions
public extension RKMsgView {
    
    ///Set RK_viewAlert message to display.
    func message(message: String!) -> Self {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration/4.0) {
            self.messageButton.setTitle(message, for: .normal)
        }
        return self
    }
    
    ///Set RK_viewAlert message icon.
    func messageIcon(icon: UIImage!) -> Self {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration/1.5) {
            self.messageButton.setImage(icon, for: .normal)
        }
        return self
    }
    
    ///Set RK_viewAlert message color.
    func messageColor(color: UIColor!) -> Self {
        self.messageButton.setTitleColor(color, for: .normal)
        return self
    }
    
    ///Set RK_viewAlert background color.
    func backgroundColor(color: UIColor!) -> Self {
        self.messageButton.backgroundColor = color
        return self
    }
    
    ///Set RK_viewAlert message font.
    func messageFont(font: UIFont!) -> Self {
        self.messageButton.titleLabel?.font = font
        return self
    }
    
    ///Handle Alert view completion.
    func completion(_ completion: @escaping () -> Void) -> Self {
        self.completion = completion
        return self
    }
    
    ///Show Alert view.
     func show() {
        self.adjustView()
        
        self.startAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                self.finishAnimating()
            }
        }
    }
}

// MARK: animation functions
extension RKMsgView {
    
    fileprivate func startAnimation(completion: @escaping () -> Void) {
        
        guard !self.isAlertShowing else {
            return
        }
        
        self.isAlertShowing = true
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y = self.unhideYPositionForAlertView
            self.layoutIfNeeded()
        }) { _ in
            completion()
        }
    }
    
    fileprivate func finishAnimating() {
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y = self.hiddenYPositionForAlertView
            
            self.alpha = 0.0
            self.layoutIfNeeded()
        }) { _ in
            self.isAlertShowing = false
            self.completion?()
        }
    }
}

// MARK: manage window hierarchy functions
extension RKMsgView {
    
    fileprivate func adjustView() {
        self.addRK_MsgAlertViewInWindow()
    }
    
    fileprivate func addRK_MsgAlertViewInWindow() {
        guard let keyWindow = UIApplication.shared.keyWindow,
            let rootViewController = keyWindow.rootViewController as? UINavigationController else {
                return
        }
        let navigationBar = rootViewController.navigationBar
        
        rootViewController.view.insertSubview(self, belowSubview: navigationBar)
    }
}

// MARK: Extensions
fileprivate extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(red: 35/255, green: 8/255, blue: 18/255, alpha: 1)
    }
}

fileprivate extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
