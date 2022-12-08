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

public func part2() -> Int {
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
    
    func trees(_ point: Point, _ check: [Point] ) -> Int {
        let max = world[point]!
        var result = 0
        for c in check {
            result += 1
            let h = world[c]!
            if h >= max {
                break
            }
        }
        return result
    }

    var result = 0
    for x in 0...maxX {
        for y in 0...maxY {
            let p = Point(x: x, y: y)
            var score = 1
            if x != maxX {
                score *= trees(p, ((x+1)...maxX).map({ Point(x: $0, y: y) }))
            }
            if x != 0 {
                score *= trees(p, (0...(x-1)).reversed().map({ Point(x: $0, y: y) }))
            }
            if y != maxY {
                score *= trees(p, ((y+1)...maxY).map({ Point(x: x, y: $0) }))
            }
            if y != 0 {
                score *= trees(p, (0...(y-1)).reversed().map({ Point(x: x, y: $0) }))
            }
            result = max(result, score)
        }
    }

    return result
}
