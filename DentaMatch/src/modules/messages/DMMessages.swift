import Foundation

protocol DMMessagesModuleInput: BaseModuleInput {
    
}

protocol DMMessagesModuleOutput: BaseModuleOutput {
    
    func showChat(chatList: ChatListModel, fetchFromBegin: Bool, delegate: ChatTapNotificationDelegate)
}

protocol DMMessagesViewInput: BaseViewInput, ChatTapNotificationDelegate {
    var viewOutput: DMMessagesViewOutput? { get set }
    
    func reloadData()
    func configureEmptyView(isHidden: Bool)
}

protocol DMMessagesViewOutput: BaseViewOutput {
    var chatListArray: [ChatListModel] { get }
    
    func didLoad()
    func willAppear()
    func refreshData()
    func blockUnblockRecruiter(id: String, isBlocked: Bool)
    func deleteChat(recruiterId: String)
    func openChat(chatList: ChatListModel, fetchFromBegin: Bool, delegate: ChatTapNotificationDelegate)
}

protocol DMMessagesPresenterProtocol: DMMessagesModuleInput, DMMessagesViewOutput {
    
}
