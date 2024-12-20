import Foundation
import UIKit

class MainCoordinator: BaseCoordinator {
    
    private lazy var mediaDataSource = MediaDataSource()
    
    override func start() {
        let viewModel = viewModelAssembly.mediaViewModel(
            dataSource: mediaDataSource
        )
        viewModel.coordinator = self
        
        let viewController = MediaViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        
        queuedPresent(viewController: navigationController, style: .root, animated: false)
    }
    
    func showPhotoLibraryAccessAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: LocalizedString("gallery_access_error_message"),
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: LocalizedString("cancel"),
            style: .default
        )
        alertController.addAction(cancelAction)
        
        let settingsAction = UIAlertAction(
            title: LocalizedString("settings"),
            style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        alertController.addAction(settingsAction)
        
        queuedPresentAlert(viewController: alertController)
    }
    
}
