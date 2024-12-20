import Foundation
import RxCocoa
import RxSwift
import Photos

struct MediaCollectionViewModel {
    
    let dataSource: BehaviorSubject<[MediaSectionModel]>
    let galleryAccessStatus: BehaviorSubject<PHAuthorizationStatus> = BehaviorSubject(value: .notDetermined)
    let isLoading = PublishRelay<Bool>()
    
    init(dataSource: BehaviorSubject<[MediaSectionModel]>) {
        self.dataSource = dataSource
    }
    
    struct Output {
        let disposable: Disposable
    }
}
