import Foundation
import UIKit

class DaySelectScreenViewController: DMBaseVC, BaseViewProtocol {

    typealias ViewClass = DaySelectScreenView

    var viewOutput: DaySelectScreenViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewOutput?.didLoad()
    }
    
    @IBAction private func acceptButtonAction() {
        viewOutput?.onAcceptButtonTapped()
    }
}

extension DaySelectScreenViewController: DaySelectScreenViewInput {

    func reloadData() {
        rootView.tableView.reloadData()
    }
}

extension DaySelectScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewOutput?.cellDescriptions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellDescriptions = viewOutput?.cellDescriptions else { return UITableViewCell() }
        return tableView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellDescriptions = viewOutput?.cellDescriptions else { return 0.0 }
        return cellDescriptions[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewOutput?.onDateTapped(index: indexPath.row)
    }
}

extension DaySelectScreenViewController {
    
    private func configureView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.register(DaySelectViewCell.self)
        
        title = "JOB DETAILS"
        navigationItem.leftBarButtonItem = backBarButton()
    }
}
