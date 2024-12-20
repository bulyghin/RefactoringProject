import UIKit
import RxSwift
import RxCocoa

struct EmptyStateStyle {
    var backgroundColor: UIColor = .white
    
    var titleText: String? = nil
    var titleColor: UIColor = .black
    var titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    var titleAlignment: NSTextAlignment = .center
    var titleNumberOfLines = 0
    
    var subtitleText: String? = nil
    var subtitleColor: UIColor = .gray
    var subtitleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    var subtitleAlignment: NSTextAlignment = .center
    var subtitleNumberOfLines = 0
    
    var insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var isLoading: Observable<Bool> = .just(false)
}
