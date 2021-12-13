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

func fold(_ world: Set<Point2D>, y: Int) -> Set<Point2D> {
    var result = Set<Point2D>()
    for p in world {
        if p.y < y {
            result.insert(p)
        } else if p.y > y {
            result.insert(Point2D(x: p.x, y: y - (p.y - y)))
        }
    }
    return result
}

public func part1() -> Int {
    var world = inputData()
    world = fold(world, x: 655)
    return world.count
}

public func part2() -> Int {
    var world = inputData()
    world = fold(world, x: 655)
    world = fold(world, y: 447)
    world = fold(world, x: 327)
    world = fold(world, y: 223)
    world = fold(world, x: 163)
    world = fold(world, y: 111)
    world = fold(world, x: 81)
    world = fold(world, y: 55)
    world = fold(world, x: 40)
    world = fold(world, y: 27)
    world = fold(world, y: 13)
    world = fold(world, y: 6)
    
    for y in 0..<13 {
        for x in 0..<40 {
            if world.contains(Point2D(x: x, y: y)) {
                print("#", terminator: "")
            } else {
                print(" ", terminator: "")
            }
        }
        print("")
    }
    
    return world.count
}
