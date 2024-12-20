import Foundation
import RxSwift
import UIKit
import SnapKit

class EmptyStateView: UIView, HasDisposeBag {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = model.style.insets
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = model.style.titleText
        label.textColor = model.style.titleColor
        label.font = model.style.titleFont
        label.textAlignment = model.style.titleAlignment
        label.numberOfLines = model.style.titleNumberOfLines
        label.isHidden = model.style.titleText.isEmpty
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = model.style.subtitleText
        label.textColor = model.style.subtitleColor
        label.font = model.style.subtitleFont
        label.textAlignment = model.style.subtitleAlignment
        label.numberOfLines = model.style.subtitleNumberOfLines
        label.isHidden = model.style.subtitleText.isEmpty
        return label
    }()
    
    private let model: EmptyState
    
    init(with model: EmptyState) {
        self.model = model
        super.init(frame: .zero)
        
        configure()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        model.style.isLoading
            .bind(to: rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}

private extension EmptyStateView {
    
    func configure() {
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        addSubview(stackView)
        
        [titleLabel, subtitleLabel]
            .forEach({stackView.addArrangedSubview($0)})
    }
    
    func setupSubviews() {
        setupStackView()
    }
    
    func setupStackView() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.centerY.equalToSuperview()
        }
    }
    
}
