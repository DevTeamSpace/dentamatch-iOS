import Foundation

protocol DMMessagesModuleInput: BaseModuleInput {
    
}

protocol DMMessagesModuleOutput: BaseModuleOutput {
    
    func showChat(chatObject: ChatObject)
}

protocol DMMessagesViewInput: BaseViewInput {
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
    func openChat(chatList: ChatListModel)
}

protocol DMMessagesPresenterProtocol: DMMessagesModuleInput, DMMessagesViewOutput {
    
}
