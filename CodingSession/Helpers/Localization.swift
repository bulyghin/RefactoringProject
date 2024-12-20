import Foundation

public func LocalizedString(_ key: String, value: String? = nil, tableName: String? = nil, bundle: Bundle = Bundle.main, comment: String? = nil) -> String {
    let fileName = "Localizable"
    let result = NSLocalizedString(key, tableName: fileName, bundle: bundle, value: value ?? key, comment: comment ?? key)
    return result == key ? NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value ?? key, comment: comment ?? key) : result
}
