import UIKit
import RxDataSources
import Photos

public enum MediaSectionModel {
    case mediaSection(title: String, items: [MediaSectionItem])
}

extension MediaSectionModel: SectionModelType {
    public typealias Item = MediaSectionItem
    
    public var identity: String {
        return title
    }
    
    public init(original: MediaSectionModel, items: [Item]) {
        switch original {
        case .mediaSection(let title, _): self = .mediaSection(title: title, items: items)
        }
    }
    
    public var items: [Item] {
        switch self {
        case .mediaSection(_, let items): return items
        }
    }
}

extension MediaSectionModel {
    
    public var title: String {
        switch self {
        case .mediaSection(let title, _): return title
        }
    }
    
}

public enum MediaSectionItem {
    case media(value: PHAsset)
}

extension MediaSectionItem: IdentifiableType {
    public typealias Identity = String
    
    public var identity: Identity {
        switch self {
        case .media(let value): return value.localIdentifier
        }
    }

}
