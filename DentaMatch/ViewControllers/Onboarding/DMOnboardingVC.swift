//
//  DMOnboardingVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMOnboardingVC: DMBaseVC {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    var images = ["onBoarding1","onBoarding2","onBoarding3","onBoarding4"]
    
    let headings = [Constants.Heading.heading1,
                    Constants.Heading.heading2,
                    Constants.Heading.heading3,
                    Constants.Heading.heading4
                    ]
    
    let subHeadings = [Constants.SubHeading.subHeading1,
                       Constants.SubHeading.subHeading2,
                       Constants.SubHeading.subHeading3,
                       Constants.SubHeading.subHeading4
                    ]
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Private Methods
    func setup() {
        skipButton.isExclusiveTouch = true
        getStartedButton.isHidden = true
        getStartedButton.isExclusiveTouch = true
    }
    
    //MARK:- IBActions
    @IBAction func skipButtonPressed(_ sender: AnyObject) {
    //Go to login/Registration
        
     let registrationContainer = UIStoryboard.registrationStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.registrationNav) as! UINavigationController
        
        UIView.transition(with: self.view.window!, duration: 0.25, options: .transitionCrossDissolve, animations: {
            kAppDelegate.window?.rootViewController = registrationContainer
        }) { (bool:Bool) in
            //completion
        }
    }
}

extension DMOnboardingVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:- CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.onBoardingImageView.image = UIImage(named: self.images[indexPath.row])
        cell.headingLabel.text = headings[indexPath.row]
        cell.subHeadingLabel.text = subHeadings[indexPath.row]
        return cell
    }
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:- ScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = onboardingCollectionView.frame.size.width;
        let page = floor((onboardingCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
        if Int(page) == 3 {
            skipButton.isHidden = true
            getStartedButton.isHidden = false
        } else {
            skipButton.isHidden = false
            getStartedButton.isHidden = true
        }
        //debugPrint(page)
    }
}

