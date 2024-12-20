import Foundation
import RxSwift
import RxCocoa

extension MediaViewModel {
    
    struct Input {
        let collectionView: MediaCollectionView
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let disposable: Disposable
    }
    
}
