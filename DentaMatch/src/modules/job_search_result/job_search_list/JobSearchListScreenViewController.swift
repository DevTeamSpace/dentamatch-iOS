import Foundation
import UIKit

class JobSearchListScreenViewController: DMBaseVC, BaseViewProtocol {

    typealias ViewClass = JobSearchListScreenView

    var viewOutput: JobSearchListScreenViewOutput?
    
    private lazy var emptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
    private lazy var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewOutput?.didLoad()
    }
}

extension JobSearchListScreenViewController: JobSearchListScreenViewInput {

    func reloadData() {
        refreshControl.endRefreshing()
        rootView.tableView.reloadData()
        updateView()
    }
    
    func reloadAt(_ indexPaths: [IndexPath]) {
        rootView.tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func addLoaderFooter() {
        guard let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView else { return }
        footer.frame = CGRect(x: 0, y: 0, width: rootView.tableView.frame.size.width, height: 44)
        footer.layoutIfNeeded()
        footer.activityIndicator.startAnimating()
        rootView.tableView.tableFooterView = footer
    }
}

extension JobSearchListScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewOutput?.jobs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as? JobSearchResultCell,
            let objJob = viewOutput?.jobs[indexPath.row] else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.delegate = viewOutput
        cell.setCellData(job: objJob)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewOutput?.openJobDetail(job: viewOutput?.jobs[indexPath.row], delegate: viewOutput)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewOutput?.loadMore(willDisplay: indexPath.row)
    }
}

extension JobSearchListScreenViewController {
    
    private func configureView() {
        
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.estimatedRowHeight = 300.0
        rootView.tableView.rowHeight = UITableView.automaticDimension
        rootView.tableView.tableFooterView = UIView()
        
        rootView.tableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        
        emptyJobsView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        emptyJobsView.center = rootView.center
        emptyJobsView.backgroundColor = UIColor.clear
        emptyJobsView.placeHolderMessageLabel.numberOfLines = 2
        emptyJobsView.isHidden = false
        emptyJobsView.layoutIfNeeded()
        emptyJobsView.placeHolderMessageLabel.text = "No Jobs found"
        rootView.addSubview(emptyJobsView)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        rootView.tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func updateView() {
        if let totalCount = viewOutput?.totalJobs, totalCount > 0 {
            rootView.resultsView.isHidden = false
            rootView.resultsLabel.text = "\(totalCount) results found"
            
            emptyJobsView.isHidden = true
        } else {
            rootView.resultsView.isHidden = true
            emptyJobsView.isHidden = false
        }
        
        rootView.tableView.tableFooterView = UIView()
    }
    
    @objc private func refreshData() {
        viewOutput?.refreshData(false)
    }
}
