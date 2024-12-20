import UIKit

class ApplicationAssembly: DependencyFactory {
    private(set) var viewModelAssembly: ViewModelAssembly?
    private(set) var coordinator: AppCoordinator?

    override init() {
        super.init()
        
        registerDependencies()
    }

    private func registerDependencies() {
        let viewModelAssembly = shared(name: "ViewModelAssembly") { ViewModelAssembly() }
        self.viewModelAssembly = viewModelAssembly

        let coordinator = shared(name: "AppCoordinator") {
            let navigationController = UINavigationController()
            return AppCoordinator(
                navigationController: navigationController,
                viewModelAssembly: viewModelAssembly
            )
        }
        self.coordinator = coordinator
    }
}
