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

func inputData2() -> Dictionary<Point2D, Int> {
    var result = Dictionary<Point2D, Int>()
    
    var y = 0
    for s in stringsFromFile() {
        guard s != "" else { continue }
        var x = 0
        for c in s {
            let n = Int(c.asciiValue!) - 48
            result[Point2D(x: x, y: y)] = n == 9 ? 9 : 0
            x = 1 + x
        }
        y = 1 + y
    }
    
    return result
}

public func part2() -> Int {
    
    func flood(_ p: Point2D, _ color: Int) {
        guard let i = data[p] else { return }
        guard i == 0 else { return }
        data[p] = color
        for n in p.neighbors() {
            flood(n, color)
        }
    }
    
    var basin = -1
    var data = inputData2()
    for x in 0...200 {
        for y in 0...200 {
            let p = Point2D(x: x, y: y)
            guard let i = data[p] else { continue }
            guard i == 0 else { continue }
            
            flood(p, basin)
            basin = basin - 1
        }
    }
    
    var counts = Dictionary<Int, Int>()
    for v in data.values {
        if v < 0 {
            counts[v] = 1 + (counts[v] ?? 0)
        }
    }
    
    return counts.values.sorted(by: { $0 > $1 }).prefix(3).reduce(1, *)
}
