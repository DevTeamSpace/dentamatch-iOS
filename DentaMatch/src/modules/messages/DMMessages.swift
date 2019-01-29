import Foundation

protocol DMMessagesModuleOutput: BaseModuleOutput {
    
    func showChat(chatList: ChatList, fetchFromBegin: Bool, delegate: ChatTapNotificationDelegate)
}
