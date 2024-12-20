import Foundation
import Photos
import RxSwift
import UIKit

extension Reactive where Base: PHImageManager {
    
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        options: PHImageRequestOptions? = nil
    ) -> Observable<UIImage?> {
        return Observable.create { [weak base] observable in

            let requestId = base?.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options,
                resultHandler: { image, info in
                    observable.onNext(image)
                    observable.onCompleted()
            })

            return Disposables.create {
                requestId.map { base?.cancelImageRequest($0) }
            }
        }
    }

}
