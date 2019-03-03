//
//  Extensions.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 03/03/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import Foundation
import UIKit

// MARK: - shortcut methods for UIViewController

extension UIApplication {
    
    //This method is used to help getting top view controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    
    //This method is used to show alert viewcontroller present on respective view controllers
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        
        present(alert, animated: true, completion: nil)
    }
    
     //This method is used to show activity indicator
    func showActivityIndicator(){
        if let applicationWindow = UIApplication.topViewController() {
            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            myActivityIndicator.center = applicationWindow.view.center
            myActivityIndicator.hidesWhenStopped = false
            applicationWindow.view.addSubview(myActivityIndicator)
            myActivityIndicator.startAnimating()
        }
    }
    
    //This method is used to hide activity indicator
    func hideActivityIndicator(){
        if let applicationWindow = UIApplication.topViewController() {
            if let animator = applicationWindow.view.subviews.first(where: {$0 is UIActivityIndicatorView})
            {
                animator.removeFromSuperview()
            }
        }
    }
}
