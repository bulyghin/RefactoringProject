import UIKit

protocol EmptyStateViewPresentable where Self: UICollectionView {
    func cofigureEmptyState() -> EmptyStateView
}
