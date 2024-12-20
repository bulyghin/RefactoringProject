import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    lazy var applicationAssembly: ApplicationAssembly = {
        let assembly = ApplicationAssembly()
        return assembly
    }()

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
            
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .white
        window?.windowScene = windowScene
            
        startScene()
        setNavigationBarAppearance()
    }
    
    private func startScene() {
        applicationAssembly.coordinator?.start()
    }
    
    private func setNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }

}

