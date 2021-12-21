import Foundation


struct Point2D: Hashable {
    let x: Int
    let y: Int
}

public func part1() -> Int {
    let depth = 8112
    let target = (x: 13, y: 743)

    var risk = 0
    var cache = Dictionary<Point2D,Int >()
    for y in 0...(target.y) {
        for x in 0...(target.x) {
            var geo = 0
            if x == 0 && y == 0 {
                geo = 0
            } else if x == 13 && y == 743 {
                geo = 0
            } else if y == 0 {
                geo = x * 16807
            } else if x == 0 {
                geo = y * 48271
            } else {
                geo = cache[Point2D(x: x-1, y: y)]! * cache[Point2D(x: x, y: y-1)]!
            }
            
            let erosion = (depth + geo) % 20183
            cache[Point2D(x: x, y: y)] = erosion
            risk = risk + (erosion % 3)
        }
    }
    
    return risk
}
