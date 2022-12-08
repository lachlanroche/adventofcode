import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
}

public func part1() -> Int {
    var maxX = 0
    var maxY = 0
    var world = [Point:Int]()
    for (y, line) in stringsFromFile().enumerated() {
        guard line != "" else { break }
        maxY = max(maxY, y)
        for (x, ch) in line.enumerated() {
            maxX = max(maxX, x)
            world[Point(x: x, y: y)] = ch.wholeNumberValue!
        }
    }
    
    var visible = Set<Point>()
    for y in 0...maxY {
        var max = -1
        for x in 0...maxX {
            let p = Point(x: x, y: y)
            if
                let h = world[p],
                h > max
            {
                visible.insert(p)
                max = h
            }
        }
        max = -1
        for x in (0...maxX).reversed() {
            let p = Point(x: x, y: y)
            if
                let h = world[p],
                h > max
            {
                visible.insert(p)
                max = h
            }
        }
    }
    
    for x in 0...maxX {
        var max = -1
        for y in 0...maxY {
            let p = Point(x: x, y: y)
            if
                let h = world[p],
                h > max
            {
                visible.insert(p)
                max = h
            }
        }
        max = -1
        for y in (0...maxY).reversed() {
            let p = Point(x: x, y: y)
            if
                let h = world[p],
                h > max
            {
                visible.insert(p)
                max = h
            }
        }
    }
    return visible.count
}
