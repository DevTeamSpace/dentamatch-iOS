import Foundation
import SwiftyJSON

extension DMJobSearchResultVC: UITableViewDataSource, UITableViewDelegate, JobSearchResultCellDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewOutput?.jobs.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as? JobSearchResultCell,
            let objJob = viewOutput?.jobs[indexPath.row] else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.delegate = self
        cell.setCellData(job: objJob)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewOutput?.openJobDetail(job: viewOutput?.jobs[indexPath.row], delegate: self)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let jobsCount = viewOutput?.jobs.count, indexPath.row == jobsCount - 1 {
            callLoadMore()
        }
    }

    // MARK: - Call Load More

    func callLoadMore() {
        if loadingMoreJobs == true {
            return
        } else {
            if let total = viewOutput?.totalJobsFromServer,
                let jobsCount = viewOutput?.jobs.count,
                let jobsPageNo = viewOutput?.jobsPageNo,
                total > jobsCount {
                
                setupLoadingMoreOnTable(tableView: tblJobSearchResult)
                loadingMoreJobs = true
                searchParams[Constants.JobDetailKey.page] = "\(jobsPageNo)"
                viewOutput?.fetchSearchResult(params: searchParams)
            }
        }
    }

    func setupLoadingMoreOnTable(tableView: UITableView) {
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
        footer?.layoutIfNeeded()
        footer?.activityIndicator.startAnimating()
        tableView.tableFooterView = footer
    }

    // MARK: - JobSearchResultCellDelegate Method

    func saveOrUnsaveJob(index: Int) {
        viewOutput?.saveOrUnsaveJob(index: index)
    }
}
