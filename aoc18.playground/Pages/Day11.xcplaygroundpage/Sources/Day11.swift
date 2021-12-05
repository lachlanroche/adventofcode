import Foundation

typealias Point = (x: Int, y: Int)

public func part1() -> (x: Int, y: Int) {
    let serial = 6548
    var result = (x: 0, y: 0)
    var maxWatts = -1_000_000
    
    for x in 0..<297 {
        for y in 0..<297 {
            let p = (x: x, y: y)
            var watts = 0
            
            for px in 0..<3 {
                for py in 0..<3 {
                    let c = (x: p.x + px, y: p.y + py)
                    let rackId = c.x + 10
                    var cell = rackId * c.y
                    cell = cell + serial
                    cell = cell * rackId
                    cell = cell / 100
                    cell = cell % 10
                    cell = cell - 5
                    watts = watts + cell
                }
            }
            
            if watts > maxWatts {
                maxWatts = watts
                result = p
            }
        }
    }
    
    return result
}
