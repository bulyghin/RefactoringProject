import Foundation
import RxCocoa
import RxSwift
import Photos

protocol MediaDataSourceProtocol: AnyObject {
        
    func getGallery(mediaType: PHAssetMediaType) -> Observable<[PHAsset]>
    
}

final class MediaDataSource {
    
}

extension MediaDataSource: MediaDataSourceProtocol {
    
    func getGallery(mediaType: PHAssetMediaType) -> Observable<[PHAsset]> {
        return Observable.create { observer in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", mediaType.rawValue)

            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
            var assets: [PHAsset] = []
            fetchResult.enumerateObjects { asset, _, _ in
                assets.append(asset)
            }

            observer.onNext(assets)
            observer.onCompleted()

            return Disposables.create()
        }
    }
    
}
