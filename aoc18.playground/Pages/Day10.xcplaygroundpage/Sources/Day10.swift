import Foundation

struct Point {
    let x: Int
    let y: Int
    let dx: Int
    let dy: Int
}

struct XY: Hashable {
    let x: Int
    let y: Int
}

extension Point {
    func step() -> Point {
        return Point(x: x + dx, y: y + dy, dx: dx, dy: dy)
    }
    
    func xy() -> XY {
        return XY(x: x, y: y)
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound, range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}

func inputData() -> [Point] {
    let input = stringsFromFile().filter { $0 != "" }
    var result = [Point]()
    
    for i in input {
        let x = Int(i[10..<16].trimmingCharacters(in: .whitespaces))!
        let y = Int(i[17..<24].trimmingCharacters(in: .whitespaces))!
        let dx = Int(i[36..<38].trimmingCharacters(in: .whitespaces))!
        let dy = Int(i[39..<42].trimmingCharacters(in: .whitespaces))!
        result.append(Point(x: x, y: y, dx: dx, dy: dy))
    }
    
    return result
}

public func part1() -> Int {
    var points = inputData()
    
    var prev = points
    var yr = 1_000_000
    var n = 0
    while true {
        points = points.map { $0.step() }
        let ys = points.map { $0.y }

        let yr2 = ys.max()! - ys.min()!

        if yr2 > yr {
            let xs = points.map { $0.x }
            let world = Set(prev.map { $0.xy() })
            
            for y in ys.min()!...ys.max()! {
                for x in xs.min()!...xs.max()! {
                    if world.contains(XY(x: x, y: y)) {
                        print("#", terminator: "")
                    } else {
                        print(" ", terminator: "")
                    }
                }
                print()
            }
            return n
        }

        prev = points
        yr = yr2
        n = 1 + n
    }
}
