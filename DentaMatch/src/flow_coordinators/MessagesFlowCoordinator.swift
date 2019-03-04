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
        guard let moduleInput = DMMessagesInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: moduleInput.viewController())
        navigationController = navController
        return navController
    }
}

extension MessagesFlowCoordinator: DMMessagesModuleOutput {
    
    func showChat(chatObject: ChatObject, delegate: ChatTapNotificationDelegate) {
        guard let moduleInput = DMChatInitializer.initialize(chatObject: chatObject, delegate: delegate, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessagesFlowCoordinator: DMChatModuleOutput {
    
    
}
