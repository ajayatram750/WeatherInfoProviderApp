//
//  Utility.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import Foundation
import UIKit


// MARK: - shortcut methods for UIViewController

extension UIViewController {
    
    /*
     Show alert
     - parameters:
     - title: the title of the alert
     - message: the message of the alert
     */
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator(){
//        if let applicationWindow = (UIApplication.shared.delegate as! AppDelegate).window {
//            //Create Activity Indicator
//            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//            myActivityIndicator.center = applicationWindow.center
//            myActivityIndicator.hidesWhenStopped = false
//            applicationWindow.addSubview(myActivityIndicator)
//            myActivityIndicator.startAnimating()
//        }
    }
    
    func hideActivityIndicator(){
//        if let applicationWindow = (UIApplication.shared.delegate as! AppDelegate).window {
//            if let animator = applicationWindow.subviews.first(where: {$0 is UIActivityIndicatorView})
//            {
//                animator.removeFromSuperview()
//            }
//        }
    }
}
