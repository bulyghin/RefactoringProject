import UIKit

class EmptyStateCollectionView: UICollectionView {
    
    weak var emptyStateDelegate: EmptyStateViewPresentable?
    
    private lazy var emptyState: EmptyStateView? = {
        return emptyStateDelegate?.cofigureEmptyState()
    }()
    
    func reloadEmptyState() {
        emptyState = emptyStateDelegate?.cofigureEmptyState()
        emptyState(show: backgroundView != nil)
    }
    
    func emptyState(show: Bool) {
        if show {
            backgroundView = emptyState
        } else {
            backgroundView = nil
        }
    }
    
}
