import Foundation
import SwiftyJSON

extension DMTrackVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let viewOutput = viewOutput else { return 0 }
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .saved:
            return viewOutput.savedJobs.count

        case .applied:
            return viewOutput.appliedJobs.count

        case .shortlisted:
            return viewOutput.shortListedJobs.count
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewOutput = viewOutput else { return }
        
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!
        switch segmentControlOptions {
        case .saved:
            if indexPath.row == viewOutput.savedJobs.count - 2 {
                callLoadMore(type: 1)
            }
        case .applied:
            if indexPath.row == viewOutput.appliedJobs.count - 2 {
                callLoadMore(type: 2)
            }
        case .shortlisted:
            if indexPath.row == viewOutput.shortListedJobs.count - 2 {
                callLoadMore(type: 3)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewOutput = viewOutput else { return UITableViewCell() }
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell

        switch segmentControlOptions {
        case .saved:
            let job = viewOutput.savedJobs[indexPath.row]
            populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.setImage(UIImage(named: "saveStar"), for: .normal)
            cell.btnFavourite.setTitle("", for: .normal)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.addTarget(self, action: #selector(removeFavouriteJobButtonPressed), for: .touchUpInside)
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.isHidden = false
            cell.selectionStyle = .none
            cell.configureWagesLabel(job: job, isSaved: true)
        case .applied:
            let job = viewOutput.appliedJobs[indexPath.row]
            populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.isHidden = true
            cell.selectionStyle = .none
            cell.configureWagesLabel(job: job, isSaved: true)
        case .shortlisted:
            let job = viewOutput.shortListedJobs[indexPath.row]
            populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.isHidden = false
            cell.btnFavourite.imageView?.image = nil
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.setTitle("n", for: .normal)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.addTarget(self, action: #selector(goToChatButton), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.configureWagesLabel(job: job, isSaved: true)
        }
        
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        openJobDetails(indexPath: indexPath)
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .saved:
            return false
        default:
            return true
        }
    }

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .applied:
            let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
                self.viewOutput?.openCancelJob(index: indexPath.row, type: .applied, fromApplied: true, delegate: self)
                self.appliedJobsTableView.setEditing(false, animated: true)
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [deleteAction]

        case .shortlisted:
            let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
                self.viewOutput?.openCancelJob(index: indexPath.row, type: .shortlisted, fromApplied: false, delegate: self)
                self.shortListedJobsTableView.setEditing(false, animated: true)
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [deleteAction]

        default:
            return nil
        }
    }

    func populateJobCellData(cell: JobSearchResultCell, job: Job) {
        cell.lblJobTitle.text = job.jobtitle
        cell.lblDocName.text = job.officeName
        cell.lblAddress.text = job.address
        cell.lblDistance.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
        cell.btnType.setTitle(getJobTypeText(jobType: job.jobType), for: .normal)
    }

    func getJobTypeText(jobType: Int) -> String {
        if jobType == 1 {
            return "Full Time"
        } else if jobType == 2 {
            return "Part Time"
        } else {
            return "Temporary"
        }
    }

    @objc func removeFavouriteJobButtonPressed(sender: UIButton) {
        
        alertMessage(title: "Confirm your action", message: "Are you sure you want to unsave the job?", leftButtonText: "Cancel", rightButtonText: "Ok") { (isLeftButton: Bool) in
            if !isLeftButton {
                self.viewOutput?.saveUnsaveJob(status: 0, index: sender.tag)
            }
        }
    }

    @objc func goToChatButton(sender: UIButton) {
        //_ = shortListedJobs[sender.tag]
    }

    func callLoadMore(type: Int) {
        viewOutput?.callLoadMore(type: type)
    }

    func setupLoadingMoreOnTable(tableView: UITableView) {
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
        footer?.layoutIfNeeded()
        footer?.activityIndicator.startAnimating()
        tableView.tableFooterView = footer
    }
    
}

extension DMTrackVC: CancelledJobDelegate {
    func cancelledJob(job: Job, fromApplied: Bool) {
        viewOutput?.cancelledJob(job, fromApplied: fromApplied)
    }
}
