import Foundation
import SwiftyJSON

class DMNotificationsPresenter: DMNotificationsPresenterProtocol {
    
    unowned let viewInput: DMNotificationsViewInput
    unowned let moduleOutput: DMNotificationsModuleOutput
    
    init(viewInput: DMNotificationsViewInput, moduleOutput: DMNotificationsModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var loadingMoreNotifications = false
    var pageNumber = 1
    var totalNotificationOnServer = 0
    var notificationList = [UserNotification]()
    var deletedNotificationList = [Int: UserNotification]() {
        willSet {
            viewInput.setDeletingBar(newValue.count)
        }
    }
    var deletingNotificationsQueue: DispatchWorkItem?
}

extension DMNotificationsPresenter: DMNotificationsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMNotificationsPresenter: DMNotificationsViewOutput {
    
    func refreshData() {
        pageNumber = 1
        
        let params = [ "page": pageNumber]
        
        
        APIManager.apiGet(serviceName: Constants.API.getNotificationList, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.notificationList.removeAll()
            
            if response[Constants.ServerKey.status].boolValue {
                let resultDic = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                self?.pageNumber += 1
                
                for dictObj in resultDic {
                    let notificationObj = UserNotification(dict: dictObj)
                    self?.notificationList.append(notificationObj)
                }
                
                self?.totalNotificationOnServer = response[Constants.ServerKey.result]["total"].intValue
                self?.viewInput.reloadData()
            } else {
                if response[Constants.ServerKey.statusCode].intValue == 201 {
                    self?.viewInput.reloadData()
                } else {
                    self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                    self?.viewInput.reloadData()
                }
            }
        }
    }
    
    func loadingMore() {
        guard !loadingMoreNotifications, totalNotificationOnServer > notificationList.count else { return }
        
        viewInput.addLoadingFooter()
        loadingMoreNotifications = true
        
        APIManager.apiGet(serviceName: Constants.API.getNotificationList, parameters: ["page": pageNumber]) { [weak self] (response: JSON?, error: NSError?) in
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                let resultDic = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                self?.pageNumber += 1
                
                for dictObj in resultDic {
                    let notificationObj = UserNotification(dict: dictObj)
                    self?.notificationList.append(notificationObj)
                }
                
                self?.totalNotificationOnServer = response[Constants.ServerKey.result]["total"].intValue
                self?.viewInput.reloadData()
            } else {
                if response[Constants.ServerKey.statusCode].intValue == 201 {
                    self?.viewInput.reloadData()
                } else {
                    self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                    self?.viewInput.reloadData()
                }
            }
        }
    }
    
    func openJobDetails(job: Job?, recruiterId: String?, notificationId: String?) {
        moduleOutput.showJobDetails(job: job, recruiterId: recruiterId, notificationId: notificationId)
    }
    
    func readNotificationToServer(_ notification: UserNotification) {
        guard let notificationId = notification.notificationID else { return }
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.readNotification, parameters: ["notificationId": notificationId]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue, let index = self?.notificationList.firstIndex(of: notification) {
                NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                self?.notificationList[index].seen = 1
                self?.viewInput.reloadData()
                self?.viewInput.redirectToDetail(notiObj: notification)
            }
        }
    }
    
    func deleteNotification(_ notification: UserNotification) {
        guard let notificationId = notification.notificationID,
            let index = notificationList.firstIndex(of: notification)
        else { return }
        
        deletedNotificationList.updateValue(
            notification,
            forKey: notificationId
        )
        notificationList.remove(at: index)
        
        deletingNotificationsQueue?.cancel()
        deletingNotificationsQueue = DispatchWorkItem(block: { [weak self] in
            self?.deleteNotifications()
        })
        guard let deletingQueue = deletingNotificationsQueue else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: deletingQueue)
    }
    
    func deleteNotifications() {
        APIManager.apiPost(serviceName: Constants.API.deleteNotification, parameters: ["notificationIds": deletedNotificationList.keys.map({$0})]) { [weak self] (response: JSON?, error: NSError?) in
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                self?.returnDeletedNotifications()
                return
            }

            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                self?.returnDeletedNotifications()
                return
            }

            if response[Constants.ServerKey.status].boolValue {
                if let deletedNotifications = self?.deletedNotificationList.values {
                    for notification in deletedNotifications {
                        if notification.seen == nil || notification.seen == 0 {
                            NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                        }
                    }
                }
                self?.deletedNotificationList.removeAll()
                self?.viewInput.reloadData()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                self?.returnDeletedNotifications()
            }
        }
    }
    
    func returnDeletedNotifications() {
        deletingNotificationsQueue?.cancel()
        notificationList.append(contentsOf: deletedNotificationList.values)
        notificationList = notificationList.sorted(by: {$0.notificationID ?? 0 > $1.notificationID ?? 0})
        deletedNotificationList.removeAll()
        viewInput.reloadData()
    }
    
    func inviteActionSend(_ notification: UserNotification, actionType: Int) {
        guard let notificationId = notification.notificationID else { return }
        
        // actionType 0 = reject ; 1 = accept
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.acceptRejectNotification, parameters: ["notificationId": notificationId, "acceptStatus": actionType]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue, let index = self?.notificationList.firstIndex(of: notification) {
                
                self?.notificationList[index].seen = 1
                NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                self?.viewInput.reloadData()
                if actionType == 1 {
                    NotificationCenter.default.post(name: .refreshMessageList, object: nil)
                }
            } else {
                
                if response[Constants.ServerKey.statusCode].intValue == 201 {
                    
                    self?.viewInput.showAlertMessage(title: "Change Availability", body: response[Constants.ServerKey.message].stringValue)
                } else {
                    
                    self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                }
            }
        }
    }
    
    func openChat(chatObject: ChatObject) {
        moduleOutput.presentChat(chatObject: chatObject)
    }
}

extension DMNotificationsPresenter {
    
}
