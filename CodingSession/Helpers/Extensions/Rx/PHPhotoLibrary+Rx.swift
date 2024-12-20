import Foundation
import Photos
import RxSwift

extension Reactive where Base: PHPhotoLibrary {
    
    static func requestAuthorization() -> Single<PHAuthorizationStatus> {
        return Single.create { single in
            PHPhotoLibrary.requestAuthorization { status in
                single(.success(status))
            }

            return Disposables.create()
        }
    }

    var photoLibraryChange: Observable<PHChange> {
        let changeObserver = RxPHPhotoLibraryObserver()
        base.register(changeObserver)

        return Observable.create { [weak base] observable in
            changeObserver.changeCallback = observable.onNext

            return Disposables.create {
                base?.unregisterChangeObserver(changeObserver)
            }
        }
    }
}

final class RxPHPhotoLibraryObserver: NSObject, PHPhotoLibraryChangeObserver {
    var changeCallback: ((PHChange) -> Void)?

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        changeCallback?(changeInstance)
    }
}
