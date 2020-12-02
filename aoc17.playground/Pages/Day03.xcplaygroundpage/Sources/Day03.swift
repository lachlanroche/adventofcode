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

extension Map {
    mutating func walk(to target: Int) {
        while true {
            right()
            guard distance < target else { x -= distance - target; break }
            up()
            guard distance < target else { y -= distance - target; break }
            step += 1
            left()
            guard distance < target else { x += distance - target; break }
            down()
            guard distance < target else { y += distance - target; break }
            step += 1
        }
    }
}

public func part1() -> Int {
    var map = Map()
    map.walk(to: 277678)
    return abs(map.x) + abs(map.y)
}

//: [Next](@next)
