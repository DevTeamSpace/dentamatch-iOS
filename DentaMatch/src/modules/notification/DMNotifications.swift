import Foundation

protocol DMNotificationsModuleInput: BaseModuleInput {
    
    func refreshData()
}

protocol DMNotificationsModuleOutput: BaseModuleOutput {
    
    func showJobDetails(job: Job?, recruiterId: String?, notificationId: String?, availableDates: [Date]?)
    func presentChat(chatObject: ChatObject)
    func showDaySelect(selectedDates: [Date], notificationId: Int)
}

protocol DMNotificationsViewInput: BaseViewInput {
    var viewOutput: DMNotificationsViewOutput? { get set }
    func reloadData()
    func addLoadingFooter()
    func redirectToDetail(notiObj: UserNotification)
    func setDeletingBar(_ notificationsCount: Int)
}

protocol DMNotificationsViewOutput: BaseViewOutput {
    var loadingMoreNotifications: Bool { get set }
    var pageNumber: Int { get set }
    var totalNotificationOnServer: Int { get set }
    var notificationList: [UserNotification] { get set }
    
    func refreshData()
    func loadingMore()
    func openJobDetails(job: Job?, recruiterId: String?, notificationId: String?)
    func readNotificationToServer(_ notification: UserNotification)
    func deleteNotification(_ notification: UserNotification)
    func inviteActionSend(_ notification: UserNotification, actionType: Int)
    func openChat(chatObject: ChatObject)
    func returnDeletedNotifications()
}

protocol DMNotificationsPresenterProtocol: DMNotificationsModuleInput, DMNotificationsViewOutput {
    
}
