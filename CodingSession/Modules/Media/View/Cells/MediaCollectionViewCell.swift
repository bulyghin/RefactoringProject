import UIKit
import SnapKit

class MediaCollectionViewCell: UICollectionViewCell, HasDisposeBag {
    
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layoutIfNeeded()
        applyGradient()
    }
    
}

private extension MediaCollectionViewCell {
    
    func configure() {
        addSubviews()
        setupSubviews()        
    }
    
    func addSubviews() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(durationLabel)
    }
    
    func setupSubviews() {
        setupThumbImageView()
        setupGradientView()
        setupDurationLabel()
    }
    
    func setupThumbImageView() {
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupGradientView() {
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func setupDurationLabel() {
        durationLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.leading.greaterThanOrEqualToSuperview().inset(8)
        }
    }
    
    func applyGradient() {
        gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = gradientView.bounds
            
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
}
