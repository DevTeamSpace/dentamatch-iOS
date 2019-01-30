import Foundation

protocol DMMessagesModuleOutput: BaseModuleOutput {
    
    func showChat(chatList: ChatListModel, fetchFromBegin: Bool, delegate: ChatTapNotificationDelegate)
}
