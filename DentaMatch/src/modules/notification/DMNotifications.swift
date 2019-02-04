import Foundation

protocol DMNotificationsModuleInput: BaseModuleInput {
    
}

protocol DMNotificationsModuleOutput: BaseModuleOutput {
    
    func showJobDetails(job: Job?)
}

protocol DMNotificationsViewInput: BaseViewInput {
    var viewOutput: DMNotificationsViewOutput? { get set }
    
    func reloadData()
    func addLoadingFooter()
    func redirectToDetail(notiObj: UserNotification)
}

protocol DMNotificationsViewOutput: BaseViewOutput {
    var loadingMoreNotifications: Bool { get set }
    var pageNumber: Int { get set }
    var totalNotificationOnServer: Int { get set }
    var notificationList: [UserNotification] { get set }
    
    func refreshData()
    func loadingMore()
    func openJobDetails(job: Job?)
    func readNotificationToServer(_ notification: UserNotification)
    func deleteNotification(_ notification: UserNotification)
    func inviteActionSend(_ notification: UserNotification, actionType: Int)
}

protocol DMNotificationsPresenterProtocol: DMNotificationsModuleInput, DMNotificationsViewOutput {
    
}
