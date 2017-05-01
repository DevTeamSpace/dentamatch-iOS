//
//  ToastView.swift
//  Order
//
//  Created by Appster on 17/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

//var kPushHeight: CGFloat {
//    return 64.0
//}

var screenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

enum ToastSkinType: Int {
    case White
    case Black
}

typealias ToasClickClosure = (() -> Void)

class ToastView: UIView {

    @IBOutlet weak var imageviewIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var isHideInitiated: Bool = false
    let animationDuration: Double = 0.3
    let showDuration: Double = 3.0
  

    var tapClosure: ToasClickClosure?

    //MARK: - Public Methods
    class func showTickToast(message: String, type: ToastSkinType)  {
        self.showTickToast(message: message, type: type, onCompletion: nil)
    }

    class func showCrossToast(message: String, type: ToastSkinType)  {
        self.showCrossToast(message: message, type: type, onCompletion: nil)
    }

    class func showTickToast(message: String, type: ToastSkinType, onCompletion: ToasClickClosure?) {
        let theImage: UIImage? = UIImage(named: "profileButton")!
        let theToast = self.makeToast(message: message, image: theImage!, type: type)
        theToast.tapClosure = onCompletion
        theToast.showToast()
    }

    class func showCrossToast(message: String, type: ToastSkinType, onCompletion: ToasClickClosure?) {
        let theImage: UIImage = UIImage(named: "profileButton")! as UIImage
        let theToast = self.makeToast(message: message, image: theImage, type: type)
        theToast.tapClosure = onCompletion
        theToast.showToast()
    }
    class func showNotificationToast(message: String , name : String, imageUrl:String?,type: ToastSkinType, onCompletion: ToasClickClosure?) {
        let theImage: UIImage? = UIImage(named: "profileButton")!
      
        let theToast = self.makeNotificationToast(message: message, name : name , image: theImage, imageUrl:imageUrl ,type: type)
        theToast.tapClosure = onCompletion
        theToast.showToast()
    }

    //MARK: - Private Methods
    private class func makeToast(message: String, image: UIImage, type: ToastSkinType) -> ToastView  {

        // Dynamic height
        let toastHeight = self.getHeightForText(messageString: message)

        // toast view
        let toast: ToastView = UINib(nibName: "ToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToastView
        toast.messageLabel.text = message
        
        toast.imageviewIcon.image = image
        toast.frame = CGRect(x:0, y:-toast.frame.size.height, width:screenWidth, height:max(toastHeight, toast.frame.size.height))

        // Add shadow
        toast.layer.shadowColor = UIColor.black.cgColor
        toast.layer.shadowOpacity = 1
        toast.layer.shadowOffset = .zero
        toast.layer.shadowRadius = 10

        // Skin Type
        if type == ToastSkinType.Black {
            toast.messageLabel.textColor = UIColor.white
            toast.backgroundColor = UIColor.init(red: 33.0 / 255.0, green: 40.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
        }

        return toast
    }
    private class func makeNotificationToast(message: String, name : String, image: UIImage?,imageUrl : String?, type: ToastSkinType) -> ToastView  {
        
        // Dynamic height
        let toastHeight = self.getHeightForText(messageString: message)
        
        // toast view
        let toast: ToastView = UINib(nibName: "ToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToastView
        toast.messageLabel.text = message
        
        toast.nameLabel.text = name
        if imageUrl != nil{
//            toast.imageviewIcon.sd_setImage(with: NSURL.init(string: imageUrl!), placeholderImage: image)
//         toast.imageviewIcon.sd_setImageWithURL(NSURL.init(string: imageUrl!), placeholderImage: image)
        }
        else{
        toast.imageviewIcon.image = image
        }
        toast.frame = CGRect(x:0, y:-toast.frame.size.height, width:screenWidth,height: max(toastHeight, toast.frame.size.height))
        
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
            toast.backgroundColor = UIColor.init(red: 33.0 / 255.0, green: 40.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
        }
        
        return toast
    }

    private func showToast()  {

        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x:0, y:0, width:screenWidth, height:self.frame.size.height)
        }) { (completed) in
            self.perform(#selector(self.dismissToast), with: nil, afterDelay: self.showDuration)
        }
    }

    func dismissToast()  {

        if self.isHideInitiated {
            return
        }

        self.isHideInitiated = true
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x:0, y:-self.frame.size.height, width:screenWidth, height:self.frame.size.height)
        }) { (completed: Bool) in
            self.removeFromSuperview()
        }
    }

    private class func getHeightForText(messageString: String) -> CGFloat {

        let maxNumberOfLine: Int = 3
        let fontSize: CGFloat = 15.0 //* Constants.SCREEN_RATIO

        let labelMaxWidth: CGFloat = screenWidth - 65.0
        let verticalPadding: CGFloat = 32.0 + 12.0
        let labelMaxHeight: CGFloat = (fontSize * CGFloat(maxNumberOfLine)) + verticalPadding

        let constraintRect = CGSize(width: labelMaxWidth, height: labelMaxHeight)

        let boundingBox = messageString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)

        LogManager.logDebug("\(boundingBox)")
        LogManager.logDebug("\(constraintRect)")

        return ceil(boundingBox.height + verticalPadding)
    }

    //MARK: - gesture
    @IBAction func swipeOccured(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            self.dismissToast()
        }
    }
    @IBAction func tapOccured(sender: UITapGestureRecognizer) {
        if self.tapClosure != nil {
            self.dismissToast()
            self.tapClosure!()
        }
    }
}
