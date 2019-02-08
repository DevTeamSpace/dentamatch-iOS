import UIKit

class DMEditSkillsVC: DMBaseVC {
    enum Skills: Int {
        case skills
        case other
    }

    @IBOutlet var navigationView: UIView!

    @IBOutlet var skillsTableView: UITableView!
    @IBOutlet weak var customNavBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSaveButtonConstraint: NSLayoutConstraint!
    
    var viewOutput: DMEditSkillsViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewOutput?.getSkillList()
    }

    func setup() {
        skillsTableView.register(UINib(nibName: "SkillsTableCell", bundle: nil), forCellReuseIdentifier: "SkillsTableCell")
        skillsTableView.register(UINib(nibName: "OtherSkillCell", bundle: nil), forCellReuseIdentifier: "OtherSkillCell")
        
        var bottomInset: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomInset = navigationController?.view.safeAreaInsets.bottom ?? 0
        }
        
        customNavBarHeightConstraint.constant = 44 + UIApplication.shared.statusBarFrame.height
        bottomSaveButtonConstraint.constant = -bottomInset
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func backButtonPressed(_: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonPressed(_: Any) {
        viewOutput?.onSaveButtonTap()
    }
}

extension DMEditSkillsVC: DMEditSkillsViewInput {
    
    func reloadData() {
        skillsTableView.reloadData()
    }
}

extension DMEditSkillsVC: SSASideMenuDelegate {
    func sideMenuWillShowMenuViewController(_: SSASideMenu, menuViewController _: UIViewController) {
        // side menu
    }

    func sideMenuWillHideMenuViewController(_: SSASideMenu, menuViewController _: UIViewController) {
        //        whiteView.isHidden = true

        if let selectedIndex = self.skillsTableView.indexPathForSelectedRow {
            skillsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        skillsTableView.reloadData()
    }
}
