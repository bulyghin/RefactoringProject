import Foundation
import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var dismissCompletion = "dismissCompletion"
    }
    
    typealias LifeCircleState = () -> Void
    
    private class StateWrapper {
        
        var state: LifeCircleState?
        
        init(state: LifeCircleState?) {
            self.state = state
        }
        
    }
    
    var dismissCompletion: LifeCircleState? {
        get {
            return dismissCompletionWrapper?.state
        }
        set {
            dismissCompletionWrapper = StateWrapper(state: newValue)
        }
    }
    
    private var dismissCompletionWrapper: StateWrapper? {
        get {
            withUnsafePointer(to: &AssociatedKeys.dismissCompletion) {
                return objc_getAssociatedObject(self, $0) as? StateWrapper
            }
        } set {
            if let value = newValue {
                withUnsafePointer(to: &AssociatedKeys.dismissCompletion) {
                    objc_setAssociatedObject(self, $0, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }
    }
    
    class func swizzleLifeCircle() {
        swizzleViewDidLoad()
        swizzleViewDidDisappear()
    }
    
    @objc class func swizzleViewDidLoad() {
        Swizzle.swizzle(
            originalSelector: #selector(UIViewController.viewDidLoad),
            swizzledSelector: #selector(UIViewController.s_viewDidLoad),
            forClass: self
        )
    }
    
    @objc class func swizzleViewDidDisappear() {
        Swizzle.swizzle(
            originalSelector: #selector(UIViewController.viewDidDisappear(_:)),
            swizzledSelector: #selector(UIViewController.s_viewDidDisappear(_:)),
            forClass: self
        )
    }
    
    
    // MARK: - Method Swizzling
    
    @objc func s_viewDidLoad() {
        s_viewDidLoad()
        
        bindViewModel()
    }
    
    @objc func s_viewDidDisappear(_ animated: Bool) {
        s_viewDidDisappear(animated)
        
        if isBeingDismissed {
            dismissCompletion?()
        }
    }
    
    
    @objc func bindViewModel() { }
    
}
