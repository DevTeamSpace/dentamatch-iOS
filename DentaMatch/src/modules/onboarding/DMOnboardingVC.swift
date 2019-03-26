import UIKit

class DMOnboardingVC: DMBaseVC {
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var collectionviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControlBottomConstraint: NSLayoutConstraint!
    
    var viewOutput: DMOnboardingViewOutput?
    var images = ["onBoarding1", "onBoarding3", "onBoarding4", "onBoarding2"]

    let headings = [
        Constants.Heading.heading1,
        Constants.Heading.heading3,
        Constants.Heading.heading4,
        Constants.Heading.heading2
    ]

    let subHeadings = [
        Constants.SubHeading.subHeading1,
        Constants.SubHeading.subHeading3,
        Constants.SubHeading.subHeading4,
        Constants.SubHeading.subHeading2
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        setup()
    }
}

extension DMOnboardingVC: DMOnboardingViewInput {
    
    
}

extension DMOnboardingVC {
    
    func setup() {
        skipButton.isExclusiveTouch = true
        getStartedButton.isHidden = true
        getStartedButton.isExclusiveTouch = true
        if UIDevice.current.screenType == .iPhone5 {
            collectionviewBottomConstraint.constant = 20
            pageControlBottomConstraint.constant = 40.0
        }
        if UIDevice.current.screenType == .iPhoneX {
            pageControlBottomConstraint.constant = 30.0
        }
    }
    
    @IBAction func skipButtonPressed(_: AnyObject) {
        UserDefaultsManager.sharedInstance.isOnBoardingDone = true
        dismiss(animated: true)
    }
}

extension DMOnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

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
    }
}
