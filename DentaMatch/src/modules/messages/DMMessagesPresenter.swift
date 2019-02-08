import Foundation
import SwiftyJSON
import RealmSwift

class DMMessagesPresenter: DMMessagesPresenterProtocol {
    
    unowned let viewInput: DMMessagesViewInput
    unowned let moduleOutput: DMMessagesModuleOutput
    
    init(viewInput: DMMessagesViewInput, moduleOutput: DMMessagesModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var chatListArray = [ChatListModel]()
    var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension DMMessagesPresenter: DMMessagesModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMMessagesPresenter: DMMessagesViewOutput {
    
    func didLoad() {
        
        let models = try! Realm().objects(ChatListModel.self)
        
        SocketIOManager.sharedInstance.initServer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToChat), name: .chatRedirect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshMessageList, object: nil)
        
        notificationToken = models.observe({ [weak self] _ in
            self?.updateUI()
        })
        
        updateUI()
        getChatLists(!models.isEmpty)
    }
    
    func willAppear() {
        SocketIOManager.sharedInstance.removeAllCompletionHandlers()
    }
    
    @objc func refreshData() {
        getChatLists(true)
    }
    
    @objc func redirectToChat(notification: Notification) {
        guard let recruiterId = notification.userInfo?["recruiterId"] as? String else { return }
        
        if let chatList = DatabaseManager.chatListExists(recruiterId: recruiterId) {
            moduleOutput.showChat(chatList: chatList,
                                  fetchFromBegin: DatabaseManager.getCountForChats(recruiterId: recruiterId) == 0,
                                  delegate: viewInput)
        }
    }
    
    func blockUnblockRecruiter(id: String, isBlocked: Bool) {
        
        let params = [
            Constants.ServerKey.recruiterId: id,
            Constants.ServerKey.blockStatus: isBlocked ? "1" : "0",
        ]
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.blockUnblockRecruiter, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                let realm = try! Realm()
                try! realm.write {
                    if let chatList = realm.objects(ChatListModel.self).filter("recruiterId == %@", id).first {
                        
                        if response[Constants.ServerKey.result][Constants.ServerKey.blockStatus].stringValue == "1" {
                            chatList.isBlockedFromSeeker = true
                            self?.viewInput.show(toastMessage: "This Recruiter is Blocked and will no longer be able to see your profile or send you messages.")
                        } else {
                            chatList.isBlockedFromSeeker = false
                            self?.viewInput.show(toastMessage: "Recruiter Unblocked")
                        }
                    }
                }
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
            
            self?.updateUI()
        }
    }
    
    func deleteChat(recruiterId: String) {
        
        let params = [
            Constants.ServerKey.recruiterId: recruiterId
        ]
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.chatDelete, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                self?.viewInput.show(toastMessage: "This chat history with this Recruiter is deleted you will no longer be able to see the previous chat.")
                
                DatabaseManager.clearChats(recruiterId: recruiterId)
                DatabaseManager.clearChatList(recruiterId: recruiterId)
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
            
            self?.updateUI()
        }
    }
    
    func openChat(chatList: ChatListModel, fetchFromBegin: Bool, delegate: ChatTapNotificationDelegate) {
        moduleOutput.showChat(chatList: chatList, fetchFromBegin: fetchFromBegin, delegate: delegate)
    }
}

extension DMMessagesPresenter {
    
    private func updateUI() {
        
        chatListArray = try! Realm().objects(ChatListModel.self).sorted(by: { $0.timeStamp > $1.timeStamp })
        
        viewInput.configureEmptyView(isHidden: chatListArray.count > 0)
        
        viewInput.reloadData()
    }
    
    private func getChatLists(_ forced: Bool = false) {
        
        if !forced {
            viewInput.showLoading()
        }
        
        APIManager.apiGet(serviceName: Constants.API.getChatUserList, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                let chatUserList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                
                if chatUserList.count > 0 {
                    
                    let realm = try! Realm()
                    try! realm.write {
                        
                        realm.add(chatUserList.map({ obj in
                            
                            let model = ChatListModel(chatListObj: obj)
                            model.date = Date(timeIntervalSince1970: (TimeInterval(obj["timestamp"].stringValue) ?? 0) / 1000)
                            return model
                            
                        }), update: true)
                    }
                }
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
            
            self?.updateUI()
        }
    }
}
