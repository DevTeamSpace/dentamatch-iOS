//
//  DMBaseVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

enum ToastPosition {
    case top
    case bottom
    case center
}

class DMBaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Toasts and Alerts
    func makeToast(toastString:String){
        kAppDelegate.window?.makeToast(toastString)
    }
    
    func makeToast(toastString:String,duration:TimeInterval){
        kAppDelegate.window?.makeToast(toastString, duration: duration, position: CSToastPositionBottom)
    }
    
    func makeToast(toastString:String,duration:TimeInterval,position:ToastPosition){
        if position == .top {
            kAppDelegate.window?.makeToast(toastString, duration: duration, position: CSToastPositionTop)
            
        } else if position == .center {
            kAppDelegate.window?.makeToast(toastString, duration: duration, position: CSToastPositionCenter)
            
        }else {
            kAppDelegate.window?.makeToast(toastString, duration: duration, position: CSToastPositionBottom)
        }
    }
    
    func cameraGalleryOptionActionSheet(title:String,message:String,leftButtonText:String,rightButtonText:String,completionHandler:((_ isCameraButtonPressed:Bool,_ isGalleryButtonPressed:Bool,_ isCancelButtonPressed:Bool)->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let leftButtonAction = UIAlertAction(title: leftButtonText, style: .default) { (action:UIAlertAction) in
            completionHandler?(true,false,false)
        }
        
        let rightButtonAction = UIAlertAction(title: rightButtonText, style: .default) { (action:UIAlertAction) in
            completionHandler?(false,true,false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            completionHandler?(false,false,true)
        }
        
        alert.addAction(leftButtonAction)
        alert.addAction(rightButtonAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(title:String,message:String,buttonText:String,completionHandler:(()->())?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertMessage(title:String,message:String,leftButtonText:String,rightButtonText:String,completionHandler:((_ isLeftButtonPressed:Bool)->())?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftButtonAction = UIAlertAction(title: leftButtonText, style: .default) { (action:UIAlertAction) in
            completionHandler?(true)
        }
        
        let rightButtonAction = UIAlertAction(title: rightButtonText, style: .default) { (action:UIAlertAction) in
            completionHandler?(false)
        }
        
        alert.addAction(leftButtonAction)
        alert.addAction(rightButtonAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    func puttingErrorPlaceholder(textfield:UITextField, placeholderText:String,placeholderColor:UIColor){
        textfield.text = ""
        textfield.placeholder = placeholderText
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSForegroundColorAttributeName : placeholderColor])
    }
    
//    func printLog(object:AnyObject?) {
//        if kLogEnabled {
//            if let message = object {
//                debugPrint(message)
//            }
//        }
//    }
    
    func backBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 19)!
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle("l", for: .normal)
        customButton.addTarget(self, action: #selector(backBarButtonItemPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }
    
    func backBarButtonItemPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func delay(time:TimeInterval,completionHandler: @escaping ()->()) {
        let when = DispatchTime.now() + 0.01
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionHandler()
        }
    }
    
    func showLoader() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.color(withHexCode: kNavBarColor))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.show()
//        self.delay(time: 0.01) { 
//            ZProgressHUD.show()
//        }
    }
    
    func showLoader(text:String) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.color(withHexCode: kNavBarColor))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.fontRegular(fontSize: 12.0)!)
        SVProgressHUD.show(withStatus: text)

//        ZProgressHUD.setFont(UIFont.fontRegular(fontSize: 12.0)!)
//        self.delay(time: 0.01) {
//            ZProgressHUD.show(text)
//        }
    }
    
    func showLoaderOnWindow() {
//        ZProgressHUD.setDefault(maskType: .custom)
//        self.delay(time: 0.01) {
//            ZProgressHUD.show()
//        }
    }
    
    func showLoaderOnWindow(text:String) {
//        ZProgressHUD.setFont(UIFont.fontRegular(fontSize: 12.0)!)
//        ZProgressHUD.setDefault(maskType: .custom)
//        self.delay(time: 0.01) {
//            ZProgressHUD.show(text)
//        }
    }

    func hideLoader() {
        SVProgressHUD.dismiss()
        //ZProgressHUD.dismiss()
    }
    
    func hideLoader(delay:TimeInterval) {
        SVProgressHUD.dismiss(withDelay: delay)
        //ZProgressHUD.dismiss(delay)
    }
}
