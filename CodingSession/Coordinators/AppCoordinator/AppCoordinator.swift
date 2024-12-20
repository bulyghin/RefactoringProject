import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {

    override func start() {
        UIViewController.swizzleLifeCircle()
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            viewModelAssembly: viewModelAssembly
        )
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()

        window?.makeKeyAndVisible()
    }
}
