import Foundation

extension DateComponentsFormatter {
    
    static var media: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional
        return formatter
    }
    
}
