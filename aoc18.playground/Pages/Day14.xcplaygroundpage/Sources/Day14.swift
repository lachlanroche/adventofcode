import Foundation


public func part1() -> [Int] {
    var data = [3, 7]
    var e0 = 0
    var e1 = 1
    
    while true {
        let r = data[e0] + data[e1]
        if r / 10 > 0 {
            data.append(1)
        }
        data.append(r % 10)
        e0 = (e0 + 1 + data[e0]) % data.count
        e1 = (e1 + 1 + data[e1]) % data.count
        
        if data.count > 880761 {
            return Array(data[880751..<880761])
        }
    }
}
