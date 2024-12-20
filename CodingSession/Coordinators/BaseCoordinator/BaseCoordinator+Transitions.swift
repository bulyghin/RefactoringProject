import Foundation
import UIKit

enum PresentationStyle {
    case push
    case modal
    case root
}

private extension BaseCoordinator {
    
    func closeTopViewController(
        condition: @escaping ((UIViewController) -> Bool),
        animated: Bool = true,
        completion: (()-> Void)?
    ) {
        DispatchQueue.main.async { [weak self] in
            guard
                let topVC = self?.topPresentedViewController(),
                condition(topVC)
            else {
                completion?()
                return
            }
            topVC.dismiss(animated: animated, completion: completion)
        }
    }
    
    func show(
        viewController: UIViewController,
        style: PresentationStyle = .push,
        animated: Bool
    ) {
        show(viewController: viewController, style: style, animated: animated, completion: {})
    }
    
    func changeRoot(
        to vc: UIViewController,
        animated: Bool,
        completion: @escaping ((Bool) -> Void)
    ) {
        guard
            let window = window
        else {
            completion(false)
            return
        }
        
        window.backgroundColor = .white
        
        if let root = window.rootViewController?.presentedViewController {
            root.dismiss(animated: animated, completion: {
                self.setRoot(window: window, vc: vc, animated: animated, completion: completion)
            })
        } else {
            setRoot(window: window, vc: vc, animated: animated, completion: completion)
        }
    }
    
    func setRoot(
        window: UIWindow,
        vc: UIViewController,
        animated: Bool,
        completion: @escaping ((Bool) -> Void)
    ) {
        dismissViewController(base: topPresentedViewController()) {
            DispatchQueue.main.async {
                window.rootViewController = vc
                UIView.transition(with: window, duration: animated ? 0.35 : 0, options: .transitionCrossDissolve, animations: {
                }, completion:{(completed) in
                    if !animated{
                        completion(true)
                        return
                    }
                    if completed{
                        completion(completed)
                    }
                })
            }
        }
    }
    
    private func dismissViewController(
        base: UIViewController?,
        completion: @escaping ()->()
    ) {
        guard
            let base = base,
            let window = window
        else {
            completion()
            return
        }
        
        if base != window.rootViewController, let presentingVC = base.presentingViewController {
            base.dismiss(animated: false, completion: { [weak self] in
                guard let self = self else {
                    completion()
                    return
                }
                self.dismissViewController(base: presentingVC, completion: completion)
            })
        } else {
            completion()
        }
    }
    
    func show(viewController: UIViewController,
              style: PresentationStyle,
              animated: Bool,
              completion: @escaping (() -> Void)
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let controller = viewController
            switch style {
            case .modal:
                self.topPresentedViewController()?.present(controller, animated: animated, completion: completion)
            case .push:
                navigationController.pushViewController(controller, animated: animated, completion: completion)
            case .root:
                self.changeRoot(to: controller, animated: animated) { _ in
                    completion()
                }
            }
        }
    }
    
    func addToQueue(
        queuePriority:  Operation.QueuePriority = .normal,
        uitask: UITask,
        semaphore: DispatchSemaphore
    ) {
        uitask.queuePriority = queuePriority
        uitask.semaphore = semaphore
        if let lastTask = presentationQueue.operations.last as? UITask, queuePriority != .veryHigh {
            uitask.addDependency(lastTask)
        }
        presentationQueue.addOperation(uitask)
    }
    
    func topPresentedViewController(_ base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? window?.rootViewController
        if let nav = base as? UINavigationController {
            return nav.visibleViewController != nil ? topPresentedViewController(nav.visibleViewController) : nav
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topPresentedViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            if presented is UISearchController {
            } else {
                return topPresentedViewController(presented)
            }
        }
        return base
    }
    
}

extension BaseCoordinator {
        
    func queuedPresent(
        queuePriority: Operation.QueuePriority = .normal,
        viewController: UIViewController,
        style: PresentationStyle,
        animated: Bool = true,
        completion: (()->())? = nil
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        let controllerName = viewController.nameOfObject
        let task = UITask { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.show(
                    viewController: viewController,
                    style: style,
                    animated: animated,
                    completion: {
                        semaphore.signal()
                        completion?()
                    })
            }
            semaphore.wait()
        }
        
        task.controller = controllerName
        addToQueue(queuePriority: queuePriority, uitask: task, semaphore: semaphore)
    }
    
    func queuedPresentAlert(viewController: UIAlertController) {
        let semaphore = DispatchSemaphore(value: 0)
        let task = UITask { [weak self] in
            guard let self = self else { return }
            viewController.dismissCompletion = {
                semaphore.signal()
            }
            DispatchQueue.main.async {
                self.show(viewController: viewController, style: .modal, animated: true)
            }
            semaphore.wait()
        }
        task.controller = viewController.nameOfObject
        addToQueue(uitask: task, semaphore: semaphore)
    }
    
    func closeModalQueued(
        queuePriority: Operation.QueuePriority = .normal,
        condition: @escaping ((UIViewController) -> Bool),
        animated: Bool = true,
        completion: (()-> ())? = nil
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        let task = UITask { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.closeTopViewController(condition: condition, animated: animated, completion: {
                    semaphore.signal()
                    completion?()
                })
            }
            semaphore.wait()
        }
        addToQueue(queuePriority: queuePriority, uitask: task, semaphore: semaphore)
    }
    
    func popQueued(
        animated: Bool = false,
        completion: (()-> ())? = nil
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        let task = UITask { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.topPresentedViewController()?.navigationController?.popViewController(animated: animated)
                semaphore.signal()
                completion?()
            }
            semaphore.wait()
        }
        addToQueue(uitask: task, semaphore: semaphore)
    }
    
}
