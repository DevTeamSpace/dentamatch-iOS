//
//  ToastView.swift
//  DentaMatch
//
//  Created by Appster on 17/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

// var kPushHeight: CGFloat {
//    return 64.0
// }

var screenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

enum ToastSkinType: Int {
    case White
    case Black
}

typealias ToasClickClosure = (() -> Void)

class ToastView: UIView {
    @IBOutlet var imageviewIcon: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

    var isHideInitiated: Bool = false
    let animationDuration: Double = 0.3
    let showDuration: Double = 3.0

    var tapClosure: ToasClickClosure?

    // MARK: - Public Methods

    class func showTickToast(message: String, type: ToastSkinType) {
        showTickToast(message: message, type: type, onCompletion: nil)
    }

    class func showCrossToast(message: String, type: ToastSkinType) {
        showCrossToast(message: message, type: type, onCompletion: nil)
    }

    class func showTickToast(message: String, type: ToastSkinType, onCompletion: ToasClickClosure?) {
        let theImage: UIImage? = UIImage(named: "profileButton")!
        let theToast = makeToast(message: message, image: theImage!, type: type)
        theToast.tapClosure = onCompletion
        theToast.showToast()
    }

    class func showCrossToast(message: String, type: ToastSkinType, onCompletion: ToasClickClosure?) {
        let theImage: UIImage = UIImage(named: "profileButton")! as UIImage
        let theToast = makeToast(message: message, image: theImage, type: type)
        theToast.tapClosure = onCompletion
        theToast.showToast()
    }

    class func showNotificationToast(message: String, name: String, imageUrl: String?, type: ToastSkinType, onCompletion: ToasClickClosure?) {
        let theImage: UIImage? = UIImage(named: "profileButton")!

        let theToast = makeNotificationToast(message: message, name: name, image: theImage, imageUrl: imageUrl, type: type)
        theToast.tapClosure = onCompletion
        theToast.showToast()
    }

    // MARK: - Private Methods

    private class func makeToast(message: String, image: UIImage, type: ToastSkinType) -> ToastView {
        // Dynamic height
        let toastHeight = getHeightForText(messageString: message)

        // toast view
        let toast: ToastView = (UINib(nibName: "ToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ToastView) ?? ToastView()
        toast.messageLabel.text = message

        toast.imageviewIcon.image = image
        toast.frame = CGRect(x: 0, y: -toast.frame.size.height, width: screenWidth, height: max(toastHeight, toast.frame.size.height))

        // Add shadow
        toast.layer.shadowColor = UIColor.black.cgColor
        toast.layer.shadowOpacity = 1
        toast.layer.shadowOffset = .zero
        toast.layer.shadowRadius = 10

        // Skin Type
        if type == ToastSkinType.Black {
            toast.messageLabel.textColor = UIColor.white
            toast.backgroundColor = UIColor(red: 33.0 / 255.0, green: 40.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
        }

        return toast
    }

    private class func makeNotificationToast(message: String, name: String, image: UIImage?, imageUrl: String?, type: ToastSkinType) -> ToastView {
        // Dynamic height
        let toastHeight = getHeightForText(messageString: message)

        // toast view
         let toast: ToastView = (UINib(nibName: "ToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ToastView) ?? ToastView()
        toast.messageLabel.text = message

        toast.nameLabel.text = name
        if imageUrl != nil {
//            toast.imageviewIcon.sd_setImage(with: NSURL.init(string: imageUrl!), placeholderImage: image)
//         toast.imageviewIcon.sd_setImageWithURL(NSURL.init(string: imageUrl!), placeholderImage: image)
        } else {
            toast.imageviewIcon.image = image
        }
        toast.frame = CGRect(x: 0, y: -toast.frame.size.height, width: screenWidth, height: max(toastHeight, toast.frame.size.height))

        // Add shadow
        toast.layer.shadowColor = UIColor.black.cgColor
        toast.layer.shadowOpacity = 1
        toast.layer.shadowOffset = .zero
        toast.layer.shadowRadius = 10
        toast.imageviewIcon.layer.cornerRadius = 25
        toast.clipsToBounds = true

        // Skin Type
        if type == ToastSkinType.Black {
            toast.messageLabel.textColor = UIColor.white
            toast.backgroundColor = UIColor(red: 33.0 / 255.0, green: 40.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
        }

        return toast
    }

    private func showToast() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.frame.size.height)
        }) { _ in
            self.perform(#selector(self.dismissToast), with: nil, afterDelay: self.showDuration)
        }
    }

    @objc func dismissToast() {
        if isHideInitiated {
            return
        }

        isHideInitiated = true
        isUserInteractionEnabled = false
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x: 0, y: -self.frame.size.height, width: screenWidth, height: self.frame.size.height)
        }) { (_: Bool) in
            self.removeFromSuperview()
        }
    }

    private class func getHeightForText(messageString: String) -> CGFloat {
        let maxNumberOfLine: Int = 3
        let fontSize: CGFloat = 15.0 // * Constants.SCREEN_RATIO

        let labelMaxWidth: CGFloat = screenWidth - 65.0
        let verticalPadding: CGFloat = 32.0 + 12.0
        let labelMaxHeight: CGFloat = (fontSize * CGFloat(maxNumberOfLine)) + verticalPadding

        let constraintRect = CGSize(width: labelMaxWidth, height: labelMaxHeight)

        let boundingBox = messageString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil)

        LogManager.logDebug("\(boundingBox)")
        LogManager.logDebug("\(constraintRect)")

        return ceil(boundingBox.height + verticalPadding)
    }

    // MARK: - gesture

    @IBAction func swipeOccured(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            dismissToast()
        }
    }

    @IBAction func tapOccured(sender _: UITapGestureRecognizer) {
        if tapClosure != nil {
            dismissToast()
            tapClosure!()
        }
    }
}
