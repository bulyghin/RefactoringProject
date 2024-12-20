import UIKit
import RxSwift
import SnapKit
import Photos
import SVProgressHUD

class MediaViewController: UIViewController {
    
    private lazy var reloadBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        return barButtonItem
    }()
    
    private let collectionView = MediaCollectionView()
    
    let viewModel: MediaViewModel
    
    init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupAppearance()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let output = viewModel.bind(input:
            MediaViewModel.Input(
                collectionView: collectionView
            )
        )
        
        let reloadDisposable = reloadBarButtonItem.rx.tap
            .bind(to: viewModel.reloadRelay)
        
        let emptyStateDisposable = Observable
            .combineLatest(
                viewModel.collectionViewDataSource.map { $0.flatMap { $0.items }.isEmpty }.skip(1),
                viewModel.galleryAccessStatus
            )
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEmpty, accessStatus in
                guard let self = self else { return }
                switch accessStatus {
                case .notDetermined:
                    self.collectionView.emptyState(show: false)
                case .authorized,
                        .limited:
                    self.collectionView.reloadEmptyState()
                    self.collectionView.emptyState(show: isEmpty)
                default:
                    self.collectionView.reloadEmptyState()
                    self.collectionView.emptyState(show: true)
                }
            })

        disposeBag.insert(
            output.disposable,
            reloadDisposable,
            emptyStateDisposable,
            output.isLoading.drive(SVProgressHUD.rx.isAnimating)
        )
        
        viewModel.checkAuthorizationAndFetchIfGranted()
    }
    
    private func setupAppearance() {
        title = LocalizedString("media_title")
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = reloadBarButtonItem
    }
    
}

private extension MediaViewController {
    
    func configure() {
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
    func setupSubviews() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
