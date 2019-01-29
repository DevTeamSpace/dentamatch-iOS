//
//  DMBaseVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Photos
import IHProgressHUD
import UIKit

enum ToastPosition {
    case top
    case bottom
    case center
}

class DMBaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.setUpControls()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setUpControls() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    func setRightBarButton(title: String, imageName: String, width: CGFloat, font: UIFont) {
        var rightBarBtn = UIButton()
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem()
        rightBarBtn = UIButton()
        rightBarBtn.setTitle(title, for: .normal)
        rightBarBtn.setImage(UIImage(named: imageName), for: .normal)
        rightBarBtn.titleLabel?.font = font
        rightBarBtn.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        rightBarBtn.imageView?.contentMode = .scaleAspectFit
        rightBarBtn.addTarget(self, action: #selector(DMJobSearchResultVC.actionRightNavigationItem), for: .touchUpInside)
        rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = rightBarBtn
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func actionLeftNavigationItem() {
        // Override in controller class
    }

    func actionRightNavigationItem() {
        // Override in controller class
    }

    // MARK: - Toasts and Alerts

    func makeToast(toastString: String) {
        kAppDelegate?.window?.makeToast(toastString)
    }

    func makeToast(toastString: String, duration: TimeInterval) {
        kAppDelegate?.window?.makeToast(toastString, duration: duration, position: CSToastPositionBottom)
    }

    func makeToast(toastString: String, duration: TimeInterval, position: ToastPosition) {
        if position == .top {
            kAppDelegate?.window?.makeToast(toastString, duration: duration, position: CSToastPositionTop)

        } else if position == .center {
            kAppDelegate?.window?.makeToast(toastString, duration: duration, position: CSToastPositionCenter)

        } else {
            kAppDelegate?.window?.makeToast(toastString, duration: duration, position: CSToastPositionBottom)
        }
    }

    func cameraGalleryOptionActionSheet(title: String, message: String, leftButtonText: String, rightButtonText: String, completionHandler: ((_ isCameraButtonPressed: Bool, _ isGalleryButtonPressed: Bool, _ isCancelButtonPressed: Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let leftButtonAction = UIAlertAction(title: leftButtonText, style: .default) { (_: UIAlertAction) in
            completionHandler?(true, false, false)
        }

        let rightButtonAction = UIAlertAction(title: rightButtonText, style: .default) { (_: UIAlertAction) in
            completionHandler?(false, true, false)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
            completionHandler?(false, false, true)
        }

        alert.addAction(leftButtonAction)
        alert.addAction(rightButtonAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func alertMessage(title: String, message: String, buttonText: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { (_: UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func alertMessage(title: String, message: String, leftButtonText: String, rightButtonText: String, completionHandler: ((_ isLeftButtonPressed: Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftButtonAction = UIAlertAction(title: leftButtonText, style: .default) { (_: UIAlertAction) in
            completionHandler?(true)
        }

        let rightButtonAction = UIAlertAction(title: rightButtonText, style: .default) { (_: UIAlertAction) in
            completionHandler?(false)
        }

        alert.addAction(leftButtonAction)
        alert.addAction(rightButtonAction)

        present(alert, animated: true, completion: nil)
    }

    func puttingErrorPlaceholder(textfield: UITextField, placeholderText: String, placeholderColor: UIColor) {
        textfield.text = ""
        textfield.placeholder = placeholderText
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }

    func backBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 19)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle("l", for: .normal)
        customButton.addTarget(self, action: #selector(backBarButtonItemPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }

    @objc func backBarButtonItemPressed() {
        _ = navigationController?.popViewController(animated: true)
    }

    func changeNavBarAppearanceForProfiles() {
        navigationController?.navigationBar.tintColor = Constants.Color.navHeadingForExperienceScreen
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constants.Color.navBarColorForExperienceScreen
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Color.navHeadingForExperienceScreen, NSAttributedString.Key.font: UIFont.fontMedium(fontSize: 14.0)]
    }

    func changeNavBarAppearanceForWithoutHeader() {
        navigationController?.navigationBar.tintColor = Constants.Color.navHeadingForExperienceScreen
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Color.navHeadingForExperienceScreen, NSAttributedString.Key.font: UIFont.fontMedium(fontSize: 14.0)]
    }

    func changeNavBarToTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func changeNavBarAppearanceForDefault() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constants.Color.navBarColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 14.0)]
    }

    func delay(time _: TimeInterval, completionHandler: @escaping () -> Void) {
        let when = DispatchTime.now() + 0.01
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionHandler()
        }
    }

    func showLoader() {
        IHProgressHUD.set(defaultMaskType: .black)
        IHProgressHUD.set(foregroundColor: Constants.Color.loaderRingColor)
        IHProgressHUD.setHUD(backgroundColor: Constants.Color.loaderBackgroundColor)
        IHProgressHUD.set(backgroundLayerColor: UIColor.clear)
        IHProgressHUD.show()
    }

    func showLoader(text: String) {
        IHProgressHUD.set(defaultMaskType: .black)
        IHProgressHUD.set(foregroundColor: Constants.Color.loaderRingColor)
        IHProgressHUD.setHUD(backgroundColor: Constants.Color.loaderBackgroundColor)
        IHProgressHUD.set(backgroundLayerColor: UIColor.clear)
        IHProgressHUD.set(font: UIFont.fontRegular(fontSize: 12.0))
        IHProgressHUD.show(withStatus: text)
    }

    func showLoaderWithInteractionOn() {
        IHProgressHUD.set(defaultMaskType: .none)
        IHProgressHUD.set(foregroundColor: Constants.Color.loaderRingColor)
        IHProgressHUD.setHUD(backgroundColor: Constants.Color.loaderBackgroundColor)
        IHProgressHUD.set(backgroundLayerColor: UIColor.clear)
        IHProgressHUD.show()
    }

    func showLoaderWithInteractionOn(text: String) {
        IHProgressHUD.set(defaultMaskType: .none)
        IHProgressHUD.set(foregroundColor: Constants.Color.loaderRingColor)
        IHProgressHUD.setHUD(backgroundColor: Constants.Color.loaderBackgroundColor)
        IHProgressHUD.set(backgroundLayerColor: UIColor.clear)
        IHProgressHUD.set(font: UIFont.fontRegular(fontSize: 12.0))
        IHProgressHUD.show(withStatus: text)
    }

    func hideLoader() {
        IHProgressHUD.dismiss()
    }

    func hideLoader(delay: TimeInterval) {
        IHProgressHUD.dismissWithDelay(delay)
    }
}
