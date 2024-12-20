import UIKit

protocol ReusableListView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableListView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionReusableView: ReusableListView { }

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(_ : T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ : T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
}


