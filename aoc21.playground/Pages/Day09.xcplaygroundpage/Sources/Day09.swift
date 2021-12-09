import Foundation

struct Point2D: Hashable {
    let x: Int
    let y: Int
}

extension Point2D {
    func neighbors() -> [Point2D] {
        return [
            Point2D(x: x, y: y - 1),
            Point2D(x: x, y: y + 1),
            Point2D(x: x - 1, y: y),
            Point2D(x: x + 1, y: y),
        ]
    }
}

func inputData() -> Dictionary<Point2D, Int> {
    var result = Dictionary<Point2D, Int>()
    
    var y = 0
    for s in stringsFromFile() {
        guard s != "" else { continue }
        var x = 0
        for c in s {
            result[Point2D(x: x, y: y)] = Int(c.asciiValue!) - 48
            x = 1 + x
        }
        y = 1 + y
    }
    
    return result
}

public func part1() -> Int {
    var result = 0

    let data = inputData()
    for x in 0...200 {
        for y in 0...200 {
            let p = Point2D(x: x, y: y)
            guard let i = data[p] else { continue }
            
            if p.neighbors().compactMap({ data[$0] }).allSatisfy({ i < $0 }) {
                result = result + i + 1
            }
        }
    }
    
    return result
}
}
