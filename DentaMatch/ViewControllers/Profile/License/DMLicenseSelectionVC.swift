//
//  DMLicenseSelectionVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMLicenseSelectionVC: DMBaseVC, UITextFieldDelegate {
    @IBOutlet var licenseTableView: UITableView!
    let profileProgress: CGFloat = 0.10
    var stateBoardImage: UIImage?
    var licenseArray: NSMutableArray?
    var jobTitles = [JobTitle]()
    var selectedJobTitle: JobTitle!

    override func viewDidLoad() {
        super.viewDidLoad()
        licenseArray = NSMutableArray()
        navigationController?.setNavigationBarHidden(false, animated: true)

        licenseArray?.addObjects(from: ["", ""])
        setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        licenseTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavBarAppearanceForWithoutHeader()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        licenseTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            licenseTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        licenseTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func setUp() {
        licenseTableView.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        licenseTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        licenseTableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        licenseTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        licenseTableView.addGestureRecognizer(tap)
        licenseTableView.separatorStyle = .none
        licenseTableView.reloadData()
        navigationItem.leftBarButtonItem = backBarButton()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func nextButtonClikced(_: Any) {
        // Dental Stateboard Removed
        for i in 0 ..< (licenseArray?.count)! {
            if let text = licenseArray?[i] as? String {
                if i == 0 {
                    if text.isEmptyField {
                        makeToast(toastString: Constants.AlertMessage.emptyLicenseNumber)
                        return
                    } else {
                        let newChar = text.first
                        if newChar == "-" {
                            makeToast(toastString: Constants.AlertMessage.lienseNoStartError)
                            return
                        }
                    }
                } else {
                    if text.isEmptyField {
                        makeToast(toastString: Constants.AlertMessage.emptyState)
                        return
                    } else {
                        let newChar = text.first
                        if newChar == "-" {
                            makeToast(toastString: Constants.AlertMessage.stateStartError)
                            return
                        }
                    }
                }
            }
        }

        let params : [String: String] = ["license": self.licenseArray![0] as? String ?? "", "state": self.licenseArray![1] as? String ?? "", "jobTitleId": "\(self.selectedJobTitle.jobId)"]
        updateLicenseAndStateAPI(params: params)
    }

    func openExperienceFirstScreen() {
        performSegue(withIdentifier: "goToWorkExperience", sender: self)
    }

    @objc func stateBoardButtonPressed(_: Any) {
        cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Take a Photo", rightButtonText: "Choose from Library") { isCameraButtonPressed, _, isCancelButtonPressed in
            if isCancelButtonPressed {
                // debugPrint("Cancel Pressed")
            } else if isCameraButtonPressed {
                CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: { [weak self] (image: UIImage?, error: NSError?) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self?.makeToast(toastString: (error?.localizedDescription)!)
                        }
                        return
                    }
                    self?.stateBoardImage = image!
                    self?.uploadDentalStateboardImage()
                    DispatchQueue.main.async {
                        self?.licenseTableView.reloadData()
                    }
                })
            } else {
                CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: {  [weak self](image: UIImage?, error: NSError?) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self?.makeToast(toastString: (error?.localizedDescription)!)
                        }
                        return
                    }
                    self?.stateBoardImage = image
                    self?.uploadDentalStateboardImage()
                    DispatchQueue.main.async {
                        self?.licenseTableView.reloadData()
                    }
                })
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "goToWorkExperience" {
            guard let destinationVC: DMWorkExperienceStart = segue.destination as? DMWorkExperienceStart else { return }
            destinationVC.selectedJobTitle = selectedJobTitle
            destinationVC.jobTitles = jobTitles
        }
    }
}
