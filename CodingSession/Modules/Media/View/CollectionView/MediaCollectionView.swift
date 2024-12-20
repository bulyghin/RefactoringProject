import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Photos

class MediaCollectionView: EmptyStateCollectionView {

    private let flowLayout: MediaCollectionViewFlowLayout = {
        let flowLayout = MediaCollectionViewFlowLayout(
            itemsPerRow: 3,
            minimumInteritemSpacing: 1,
            minimumLineSpacing: 1
        )
        return flowLayout
    }()
    
    final class GalleryCollectionDataSource: RxCollectionViewSectionedReloadDataSource<MediaSectionModel> {}
    public var rxDataSource: GalleryCollectionDataSource?
    
    private let isLoading = PublishRelay<Bool>()
    let galleryAccessStatus: BehaviorSubject<PHAuthorizationStatus> = BehaviorSubject(value: .notDetermined)
    
    required init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        contentInsetAdjustmentBehavior = .never
        emptyStateDelegate = self

        registerCell(MediaCollectionViewCell.self)

        initRxDataSource()
    }

    private func initRxDataSource() {
        rxDataSource = GalleryCollectionDataSource(configureCell: { [weak self] (_, collectionView, index, item) -> UICollectionViewCell in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .media(let value):
                let cell = collectionView.dequeueReusableCell(MediaCollectionViewCell.self, for: index)
                PHImageManager.default().rx
                    .requestImage(
                        for: value,
                        targetSize: self.flowLayout.itemSize,
                        contentMode: .aspectFill
                    )
                    .observe(on: MainScheduler.instance)
                    .bind(to: cell.thumbImageView.rx.image)
                    .disposed(by: cell.disposeBag)
                cell.durationLabel.text = DateComponentsFormatter.media.string(from: value.duration)
                return cell
            }
        })
    }

    func bind(_ viewModel: MediaCollectionViewModel) -> MediaCollectionViewModel.Output {
        let dataSourceBinding = viewModel.dataSource.bind(to: rx.items(dataSource: rxDataSource!))

        return MediaCollectionViewModel.Output(
            disposable: Disposables.create([
                dataSourceBinding,
                viewModel.galleryAccessStatus.bind(to: galleryAccessStatus),
                viewModel.isLoading.bind(to: isLoading)
            ])
        )
    }
}

extension MediaCollectionView: EmptyStateViewPresentable {
    
    func cofigureEmptyState() -> EmptyStateView {
        var subtitleText: String?
        switch try? galleryAccessStatus.value() {
        case .authorized,
                .limited:
            break
        default:
            subtitleText = LocalizedString("gallery_access_error_message")
        }
        let model = EmptyState.Builder()
            .titleText(LocalizedString("media_empty_state_no_media"))
            .subtitleText(subtitleText)
            .isLoading(isLoading.asObservable())
            .build()
        return EmptyStateView(with: model)
    }
    
}
