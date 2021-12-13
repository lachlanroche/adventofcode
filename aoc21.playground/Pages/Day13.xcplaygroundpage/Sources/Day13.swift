import Foundation


struct Point2D: Hashable {
    let x: Int
    let y: Int
}

func inputData() -> Set<Point2D> {
    var result = Set<Point2D>()
    for s in stringsFromFile() {
        guard s.contains(",") else { continue }
        let xy = s.components(separatedBy: ",")
        result.insert(Point2D(x: Int(xy[0])!, y: Int(xy[1])!))
    }
    return result
}

func fold(_ world: Set<Point2D>, x: Int) -> Set<Point2D> {
    var result = Set<Point2D>()
    for p in world {
        if p.x < x {
            result.insert(p)
        } else if p.x > x {
            result.insert(Point2D(x: x - (p.x - x), y: p.y))
        }
    }
    return result
}

public func part1() -> Int {
    var world = inputData()
    world = fold(world, x: 655)
    return world.count
}

