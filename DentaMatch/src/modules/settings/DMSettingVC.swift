import UIKit

class DMSettingVC: DMBaseVC {
    @IBOutlet var settingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    var viewOutput: DMSettingsViewOutput?

    func setup() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()

        settingTableView.register(UINib(nibName: "SettingTableCell", bundle: nil), forCellReuseIdentifier: "SettingTableCell")
        settingTableView.separatorStyle = .none
        title = Constants.ScreenTitleNames.settings
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        changeNavBarAppearanceForDefault()
    }
}

extension DMSettingVC: DMSettingsViewInput {
    
    
}
