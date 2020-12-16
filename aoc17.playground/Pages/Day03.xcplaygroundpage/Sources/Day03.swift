import Foundation


struct Map {
    var x = 0
    var y = 0
    var step = 1
    var distance = 1
    mutating func right() {
        x += 1
        distance += 1
    }
    mutating func up() {
        y += 1
        distance += 1
    }
    mutating func left() {
        x -= 1
        distance += 1
    }
    mutating func down() {
        y -= 1
        distance += 1
    }
}

extension Map {
    mutating func walk(to target: Int) {
        while true {
            for _ in 0..<step {
                right()
                guard distance != target else { return }
            }
            for _ in 0..<step {
                up()
                guard distance != target else { return }
            }
            step += 1
            for _ in 0..<step {
                left()
                guard distance != target else { return }
            }
            for _ in 0..<step {
                down()
                guard distance != target else { return }
            }
            step += 1
        }
    }
}

public func part1() -> Int {
    var map = Map()
    map.walk(to: 277678)
    return abs(map.x) + abs(map.y)
}
