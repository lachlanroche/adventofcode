import Foundation


struct Map {
    var x = 0
    var y = 0
    var step = 1
    var distance = 1
    mutating func right() {
        x += step
        distance += step
    }
    mutating func up() {
        y += step
        distance += step
    }
    mutating func left() {
        x -= step
        distance += step
    }
    mutating func down() {
        y -= step
        distance += step
    }
}

func walk(to target: Int) -> (Int, Int) {
    var map = Map()
    while true {
        map.right()
        guard map.distance < target else { map.x -= map.distance - target; break }
        map.up()
        guard map.distance < target else { map.y -= map.distance - target; break }
        map.step += 1
        map.left()
        guard map.distance < target else { map.x += map.distance - target; break }
        map.down()
        guard map.distance < target else { map.y += map.distance - target; break }
        map.step += 1
    }
    return (map.x, map.y)
}

public func part1() -> Int {
    let xy = walk(to: 277678)
    return abs(xy.0) + abs(xy.1)
}

//: [Next](@next)
