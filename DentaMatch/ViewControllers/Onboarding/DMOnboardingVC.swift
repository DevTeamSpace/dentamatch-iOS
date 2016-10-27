//
//  DMOnboardingVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMOnboardingVC: DMBaseVC {


    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
    }
    @IBAction func skipButtonPressed(_ sender: AnyObject) {
        //Go to login/Registration
        
     let registrationContainer = UIStoryboard.registrationStoryBoard().instantiateViewController(withIdentifier: "RegistrationNAV") as! UINavigationController
  
    kAppDelegate.window?.rootViewController = registrationContainer
//        [UIView transitionWithView:self.sourceViewController.view.window
//            duration:0.5
//            options:UIViewAnimationOptionTransitionCrossDissolve
//            animations:^{
//            self.sourceViewController.view.window.rootViewController = self.destinationViewController;
//            } completion:^(BOOL finished) {
//            // Code to run after animation
//            }];
    }
}

extension DMOnboardingVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:- CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
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
        print(page)
    }
}

