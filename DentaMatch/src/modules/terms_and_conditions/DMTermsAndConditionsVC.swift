import UIKit

class FullScreenWebView: UIWebView {
    
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

class DMTermsAndConditionsVC: DMBaseVC {
    @IBOutlet var webView: FullScreenWebView!
    
    var viewOutput: DMTermsAndConditionsViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOutput?.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if navigationController?.viewControllers.contains(where: { $0 is DMSettingVC }) == false {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        hideLoader()
    }
}

extension DMTermsAndConditionsVC: DMTermsAndConditionsViewInput {
    
    func configureWebView(isPrivacyPolicy: Bool) {
        
        showLoader()
        title = isPrivacyPolicy ? "PRIVACY POLICY" : "TERMS & CONDITIONS"
        let request = isPrivacyPolicy ?
            URLRequest(url: URL(string: Constants.API.privacyPolicyURL)!) :
            URLRequest(url: URL(string: Constants.API.termsAndConditionsURL)!)
        webView.delegate = self
        webView.loadRequest(request)
        navigationItem.leftBarButtonItem = backBarButton()
        navigationController?.navigationBar.barTintColor = Constants.Color.navBarColor
    }
}

extension DMTermsAndConditionsVC: UIWebViewDelegate {

    func webView(_: UIWebView, didFailLoadWithError _: Error) {
        hideLoader()
    }

    func webViewDidFinishLoad(_: UIWebView) {
        hideLoader()
    }
}
