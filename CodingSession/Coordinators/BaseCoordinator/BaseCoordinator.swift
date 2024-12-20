import Foundation
import UIKit

class BaseCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var viewModelAssembly: ViewModelAssembly
    
    let presentationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }

    init(navigationController: UINavigationController, viewModelAssembly: ViewModelAssembly) {
        self.navigationController = navigationController
        self.viewModelAssembly = viewModelAssembly
    }

    func start() { }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
