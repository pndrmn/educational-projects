import UIKit

//MARK: 2
extension Int {
    
    func times(closure: () -> Void) {

        guard self > 0 else { return }
        
        for _ in 0..<self {
            closure()
        }
    }
}
5.times {print("Hello!")}

//MARK: 3
extension Array where Element: Comparable {
    
    mutating func remove(item: Element) {
        
        self.remove(at: (firstIndex(of: item)!))
    }
}

var testArray = [1,2,3,3,4,5,3]
testArray.remove(item: 3)

