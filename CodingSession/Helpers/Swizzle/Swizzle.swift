import Foundation

class Swizzle {
    
    class func swizzle(
        originalSelector: Selector,
        swizzledSelector: Selector,
        forClass klass: AnyClass
    ) {
        guard let originalMethod = class_getInstanceMethod(klass, originalSelector) else {
            return
        }
        guard let swizzledMethod = class_getInstanceMethod(klass, swizzledSelector) else {
            return
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
}
