import Foundation

extension NSObject {

    var nameOfObject: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }

}
