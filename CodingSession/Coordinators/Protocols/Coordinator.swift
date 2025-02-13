import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var viewModelAssembly: ViewModelAssembly { get set }

    func start()
}
