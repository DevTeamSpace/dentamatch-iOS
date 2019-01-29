import Foundation
import UIKit
import Swinject

protocol MessagesFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol MessagesFlowCoordinatorDelegate: class {
    
}

class MessagesFlowCoordinator: BaseFlowCoordinator, MessagesFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: MessagesFlowCoordinatorDelegate
    
    init(delegate: MessagesFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let vc = DMMessagesInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
}

extension MessagesFlowCoordinator: DMMessagesModuleOutput {
    
    func showChat(chatList: ChatList, fetchFromBegin: Bool, delegate: ChatTapNotificationDelegate) {
        guard let vc = DMChatInitializer.initialize(chatList: chatList, delegate: delegate, fetchFromBegin: fetchFromBegin, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessagesFlowCoordinator: DMChatModuleOutput {
    
    
}
