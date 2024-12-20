import Foundation

private struct BaseViewModelAssociatedKeys {
    static var coordinator = "coordinator"
}

protocol CoordinatorAssociated where Self: NSObject {
    associatedtype CoordinatorType
    var coordinator: CoordinatorType? { get set }
}

extension CoordinatorAssociated {
    
    var coordinator: CoordinatorType? {
        get {
            withUnsafePointer(to: &BaseViewModelAssociatedKeys.coordinator) {
                return objc_getAssociatedObject(self, $0) as? CoordinatorType
            }
        } set {
            if let value = newValue {
                withUnsafePointer(to: &BaseViewModelAssociatedKeys.coordinator) {
                    objc_setAssociatedObject(self, $0, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }
    }
    
}

class BaseViewModel<CoordinatorType>: NSObject & CoordinatorAssociated {
    
    weak var viewModelAssembly: ViewModelAssembly?
    
    func initialize() { }
    
}
