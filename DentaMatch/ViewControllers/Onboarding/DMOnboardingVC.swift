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
    @IBOutlet weak var pageControlBottomConstraint: NSLayoutConstraint!
    var images = ["onBoarding1", "onBoarding2", "onBoarding3", "onBoarding4"]

    let headings = [
        Constants.Heading.heading1,
        Constants.Heading.heading2,
        Constants.Heading.heading3,
        Constants.Heading.heading4,
    ]

    let subHeadings = [
        Constants.SubHeading.subHeading1,
        Constants.SubHeading.subHeading2,
        Constants.SubHeading.subHeading3,
        Constants.SubHeading.subHeading4,
    ]

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setup()
        // Do any additional setup after loading the view.
    }

    // MARK: - Private Methods

    func setup() {
        skipButton.isExclusiveTouch = true
        getStartedButton.isHidden = true
        getStartedButton.isExclusiveTouch = true
        if UIDevice.current.screenType == .iPhoneX {
            pageControlBottomConstraint.constant = 30.0
        }
    }

    // MARK: - IBActions
    @IBAction func skipButtonPressed(_: AnyObject) {
        // Go to login/Registration
        guard let registrationContainer = UIStoryboard.registrationStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.registrationNav) as? UINavigationController else {return}

        UIView.transition(with: view.window!, duration: 0.25, options: .transitionCrossDissolve, animations: {
            kAppDelegate?.window?.rootViewController = registrationContainer
        }) { (_: Bool) in
            // completion
        }
    }
}

extension DMOnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - CollectionView Datasource

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.onBoardingImageView.image = UIImage(named: images[indexPath.row])
        cell.headingLabel.text = headings[indexPath.row]
        cell.headingLabel.setLineHeightT(5.0)
        cell.subHeadingLabel.text = subHeadings[indexPath.row]
        cell.subHeadingLabel.setLineHeightT(5.0)
        return cell
    }

    // MARK: - CollectionView Delegate

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    // MARK: - ScrollView Delegates

    func scrollViewDidEndDecelerating(_: UIScrollView) {
        let pageWidth = onboardingCollectionView.frame.size.width
        let page = floor((onboardingCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
        if Int(page) == 3 {
            skipButton.isHidden = true
            getStartedButton.isHidden = false
        } else {
            skipButton.isHidden = false
            getStartedButton.isHidden = true
        }
        // debugPrint(page)
    }
}
