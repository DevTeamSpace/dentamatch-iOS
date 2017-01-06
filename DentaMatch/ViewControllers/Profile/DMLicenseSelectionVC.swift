//
//  DMLicenseSelectionVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMLicenseSelectionVC: DMBaseVC,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var licenseTableView: UITableView!
    
    var stateBoardImage:UIImage? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    func setUp() {
        self.licenseTableView.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.licenseTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.licenseTableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        self.licenseTableView.separatorStyle = .none
        self.licenseTableView.reloadData()
        self.navigationItem.leftBarButtonItem = self.backBarButton()

        self.changeNavBarAppearanceForWithoutHeader()
        navSetUp()

    }
    func navSetUp()
    {
        
    }
    
    @IBAction func nextButtonClikced(_ sender: Any) {
        self.performSegue(withIdentifier: "goToWorkExperience", sender: self)
    }
    
    func stateBoardButtonPressed(_ sender: Any) {
        self.cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Camera", rightButtonText: "Gallery") { (isCameraButtonPressed, isGalleryButtonPressed, isCancelButtonPressed) in
            if isCancelButtonPressed {
            } else if isCameraButtonPressed {
                CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: { (image:UIImage?, error:NSError?) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.makeToast(toastString: (error?.localizedDescription)!)
                        }
                        return
                    }
                    self.stateBoardImage = image!
                    DispatchQueue.main.async {
//                        self.profileButton.setImage(image, for: .normal)
                        self.licenseTableView.reloadData()
                    }
                })
            } else {
                CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: { (image:UIImage?, error:NSError?) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.makeToast(toastString: (error?.localizedDescription)!)
                        }
                        return
                    }
                    self.stateBoardImage = image
                    DispatchQueue.main.async {
                        self.licenseTableView.reloadData()
                    }
                })
            }
        }
    }
    

    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1
        {
            return 1
        }
        return 2
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.frame.origin.x = 20
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.font = UIFont.fontMedium(fontSize: 14)
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        if section == 1
        {
            headerLabel.text = "ADD DENTAL STATE BOARD"
        }else{
            headerLabel.text = "LICENSE"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 226
 
        }else if indexPath.section == 1        {
            return 203
            
        }
        return 99

    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.selectionStyle = .none

            return cell

        case 1:
            print("section 1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            
            cell.stateBoardPhotoButton.addTarget(self, action: #selector(DMLicenseSelectionVC.stateBoardButtonPressed(_:)), for: .touchUpInside)
            if self.stateBoardImage == nil{
                cell.stateBoardPhotoButton .setTitle("h", for: .normal)
            }else{
                cell.stateBoardPhotoButton .setTitle("", for: .normal)
                cell.stateBoardPhotoButton.alpha = 1.0
                cell.stateBoardPhotoButton.backgroundColor = UIColor.clear
                cell.stateBoardPhotoButton.setImage(self.stateBoardImage!, for: .normal)
            }

            cell.selectionStyle = .none
            return cell

            
        case 2:
            print("section 2")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            cell.selectionStyle = .none

            if indexPath.row == 0
            {
                cell.cellTopSpace.constant = 43.5
                cell.cellBottomSpace.constant = 10.5
                cell.commonTextFiled.placeholder = "License Number"
                cell.layoutIfNeeded()
            }else if indexPath.row == 1
            {
                cell.commonTextFiled.placeholder = "State"
                cell.cellTopSpace.constant = 10.5
                cell.cellBottomSpace.constant = 41.5
                cell.layoutIfNeeded()
            }
            return cell

        case 3:
            print("section 3")


            
        default:
            print("Default")
            
        }
        
       return UITableViewCell()
    }
    

}
