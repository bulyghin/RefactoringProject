import Foundation
import RxSwift
import RxCocoa
import Photos

final class MediaViewModel: BaseViewModel<MainCoordinator>, HasDisposeBag {

    private let dataSource: MediaDataSourceProtocol
    
    private let isLoading = ActivityIndicator()
    let reloadRelay = PublishRelay<Void>()
    
    let collectionViewDataSource: BehaviorSubject<[MediaSectionModel]> = BehaviorSubject(value: [])
    let galleryAccessStatus: BehaviorSubject<PHAuthorizationStatus> = BehaviorSubject(value: .notDetermined)
    
    init(dataSource: MediaDataSourceProtocol) {
        self.dataSource = dataSource
        
        super.init()
    }
    
    override func initialize() {
        super.initialize()
        
        reloadRelay.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.checkAuthorizationAndFetchIfGranted()
        }).disposed(by: disposeBag)
        
        PHPhotoLibrary.shared().rx
            .photoLibraryChange
            .subscribe(onNext: { [weak self] change in
                guard let self = self else { return }
                self.checkAuthorizationAndFetchIfGranted()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public
    
    func bind(input: Input) -> Output {
        let collectionViewModel = MediaCollectionViewModel(
            dataSource: collectionViewDataSource
        )
        let output = input.collectionView.bind(collectionViewModel)
        
        return Output(
            isLoading: isLoading.asDriver(),
            disposable: Disposables.create([
                output.disposable,
                galleryAccessStatus.bind(to: collectionViewModel.galleryAccessStatus),
                isLoading.asObservable().bind(to: collectionViewModel.isLoading)
            ])
        )
    }
    
    func checkAuthorizationAndFetchIfGranted() {
        PHPhotoLibrary.rx
            .requestAuthorization()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] status in
                guard let self = self else { return }
                self.galleryAccessStatus.onNext(status)
                switch status {
                case .authorized,
                        .limited:
                    self.fetchAssets(mediaType: .video).disposed(by: self.disposeBag)
                default:
                    self.coordinator?.showPhotoLibraryAccessAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    
    private func fetchAssets(mediaType: PHAssetMediaType) -> Disposable {
        return dataSource
            .getGallery(mediaType: mediaType)
            .trackActivity(isLoading)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] assets in
                guard let self = self else { return }
                let items = assets.map({MediaSectionItem.media(value: $0)})
                self.collectionViewDataSource.onNext(
                    [.mediaSection(
                        title: LocalizedString("media_title"),
                        items: items
                    )]
                )
            })
    }
    
}
