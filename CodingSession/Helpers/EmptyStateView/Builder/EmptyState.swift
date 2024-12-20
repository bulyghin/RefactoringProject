import UIKit
import RxSwift
import RxCocoa

class EmptyState {
    
    let style: EmptyStateStyle
    
    static var `default`: EmptyState = Builder().build()
    
    private init(style: EmptyStateStyle) {
        self.style = style
    }
    
    class Builder {
        
        private var style: EmptyStateStyle = EmptyStateStyle()
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            style.backgroundColor = backgroundColor
            return self
        }
        
        func titleText(_ titleText: String?) -> Builder {
            style.titleText = titleText
            return self
        }
        
        func titleColor(_ titleColor: UIColor) -> Builder {
            style.titleColor = titleColor
            return self
        }
        
        func titleFont(_ titleFont: UIFont) -> Builder {
            style.titleFont = titleFont
            return self
        }
        
        func titleAlignment(_ titleAlignment: NSTextAlignment) -> Builder {
            style.titleAlignment = titleAlignment
            return self
        }
        
        func titleNumberOfLines(_ titleNumberOfLines: Int) -> Builder {
            style.titleNumberOfLines = titleNumberOfLines
            return self
        }
        
        func subtitleText(_ subtitleText: String?) -> Builder {
            style.subtitleText = subtitleText
            return self
        }
        
        func subtitleColor(_ subtitleColor: UIColor) -> Builder {
            style.subtitleColor = subtitleColor
            return self
        }
        
        func subtitleFont(_ subtitleFont: UIFont) -> Builder {
            style.subtitleFont = subtitleFont
            return self
        }
        
        func subtitleAlignment(_ subtitleAlignment: NSTextAlignment) -> Builder {
            style.subtitleAlignment = subtitleAlignment
            return self
        }
        
        func subtitleNumberOfLines(_ subtitleNumberOfLines: Int) -> Builder {
            style.subtitleNumberOfLines = subtitleNumberOfLines
            return self
        }
        
        func insets(_ insets: UIEdgeInsets) -> Builder {
            style.insets = insets
            return self
        }
        
        func isLoading(_ isLoading: Observable<Bool>) -> Builder {
            style.isLoading = isLoading
            return self
        }
        
        func build() -> EmptyState {
            return EmptyState(style: style)
        }
    }
    
}
