import Foundation

protocol DMChatModuleInput: BaseModuleInput {
    
}

protocol DMChatModuleOutput: BaseModuleOutput {
    
}

protocol DMChatViewInput: BaseViewInput {
    var viewOutput: DMChatViewOutput? { get set }
    
    func reloadData()
    func configureView(title: String?, isBlockFromSeeker: Bool)
    func configureMessageReceive()
    func scrollToBottom()
}

protocol DMChatViewOutput: BaseViewOutput {
    var chatsArray: [[ChatModel]] { get }
    
    func didLoad()
    func willAppear()
    func willDisappear()
    func sendMessage(text: String)
    func onUblockButtonTap()
    func onNotificationTap(recruiterId: String)
}

protocol DMChatPresenterProtocol: DMChatModuleInput, DMChatViewOutput {
    
}
