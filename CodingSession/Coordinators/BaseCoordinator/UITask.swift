import Foundation

class UITask: BlockOperation, @unchecked Sendable {
    var controller: String?
    var semaphore: DispatchSemaphore?
    var group: DispatchGroup?
    
    override func cancel() {
        super.cancel()
        semaphore?.signal()
        group?.leave()
    }
    
}
