//
//  DMRegistrationContainer.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMRegistrationContainer: DMBaseVC {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationHeaderImageView: UIImageView!
    
    var registrationVC:DMRegistrationVC?
    var loginVC:DMLoginVC?
    var isRegistration = true
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registrationVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegistrationVC.self)!
        registrationVC?.view.frame = CGRect(x: 0, y: self.topView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.topView.frame.size.height)
        
        loginVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMLoginVC.self)!
        loginVC?.view.frame = CGRect(x: 0, y: self.topView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.topView.frame.size.height)
        
        self.addChildViewController(loginVC!)
        self.view.addSubview((loginVC?.view)!)
        self.addChildViewController(registrationVC!)
        self.view.addSubview((registrationVC?.view)!)
        
        if UserDefaultsManager.sharedInstance.isLoggedOut {
            registrationVC?.didMove(toParentViewController: self)
            loginVC?.didMove(toParentViewController: self)
            registrationVC?.view.alpha = 0.0
            isRegistration = false

        } else {
            loginVC?.didMove(toParentViewController: self)
            registrationVC?.didMove(toParentViewController: self)
            loginVC?.view.alpha = 0.0
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registrationVC?.view.frame = CGRect(x: 0, y: self.topView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.topView.frame.size.height)
        
        loginVC?.view.frame = CGRect(x: 0, y: self.topView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.topView.frame.size.height)
        
        UIView.removeTip(view: registrationButton)
        UIView.removeTip(view: loginButton)
        
        if isRegistration {
            registrationButton.titleLabel?.font = UIFont.fontSemiBold(fontSize: 14.0)!
            loginButton.titleLabel?.font = UIFont.fontLight(fontSize: 14.0)!
            UIView.makeTip(view: registrationButton, size: 8, x: registrationButton.frame.midX/2, y: registrationButton.frame.midY)
        } else {
            registrationButton.titleLabel?.font = UIFont.fontLight(fontSize: 14.0)!
            loginButton.titleLabel?.font = UIFont.fontSemiBold(fontSize: 14.0)!
            UIView.makeTip(view: loginButton, size: 8, x: loginButton.frame.midX/2, y: loginButton.frame.midY)
        }
        
        if UserDefaultsManager.sharedInstance.isLoggedOut {
            //goToLoginFromLogout()
        }
    }
    
    //MARK:- IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        isRegistration = false
        registrationButton.titleLabel?.font = UIFont.fontLight(fontSize: 14.0)!
        loginButton.titleLabel?.font = UIFont.fontSemiBold(fontSize: 14.0)!
        UIView.removeTip(view: registrationButton)
        UIView.makeTip(view: sender, size: 8, x: sender.frame.midX/2, y: sender.frame.midY)
        self.view.endEditing(true)
        self.view.bringSubview(toFront: (self.loginVC?.view)!)
        UIView.animate(withDuration: 0.25, animations: {
            self.loginVC?.view.alpha = 1.0
            self.registrationVC?.view.alpha = 0.0
        }) { (finished:Bool) in
            //completion

        }
    }

    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        isRegistration = true
        registrationButton.titleLabel?.font = UIFont.fontSemiBold(fontSize: 14.0)!
        loginButton.titleLabel?.font = UIFont.fontLight(fontSize: 14.0)!
        UIView.removeTip(view: loginButton)
        UIView.makeTip(view: sender, size: 8, x: sender.frame.midX/2, y: sender.frame.midY)
        self.view.endEditing(true)
        self.view.bringSubview(toFront: (registrationVC?.view)!)
        UIView.animate(withDuration: 0.25, animations: {
            self.registrationVC?.view.alpha = 1.0
            self.loginVC?.view.alpha = 0.0
        }) { (finished:Bool) in
            //completion
        }
    }
    
    func goToLoginAfterRegistration() {
        isRegistration = false
        registrationButton.titleLabel?.font = UIFont.fontLight(fontSize: 14.0)!
        loginButton.titleLabel?.font = UIFont.fontSemiBold(fontSize: 14.0)!
        UIView.removeTip(view: registrationButton)
        UIView.makeTip(view: loginButton, size: 8, x: loginButton.frame.midX/2, y: loginButton.frame.midY)
        self.view.endEditing(true)
        self.view.bringSubview(toFront: (self.loginVC?.view)!)
        loginVC?.clearData()
        UIView.animate(withDuration: 0.25, animations: {
            self.loginVC?.view.alpha = 1.0
            self.registrationVC?.view.alpha = 0.0
        }) { (finished:Bool) in
            //completion

        }
    }
    
    func goToLoginFromLogout() {
        isRegistration = false
        registrationButton.titleLabel?.font = UIFont.fontLight(fontSize: 14.0)!
        loginButton.titleLabel?.font = UIFont.fontSemiBold(fontSize: 14.0)!
        UIView.removeTip(view: registrationButton)
        UIView.makeTip(view: loginButton, size: 8, x: loginButton.frame.midX/2, y: loginButton.frame.midY)
        self.view.endEditing(true)
        self.view.bringSubview(toFront: (self.loginVC?.view)!)
        loginVC?.clearData()
        self.loginVC?.view.alpha = 1.0
        self.registrationVC?.view.alpha = 0.0
    }
}
