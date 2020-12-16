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

struct Point: Hashable {
    let x: Int
    let y: Int
}

public func part2() -> Int {
    var map = Map()
    var values = Dictionary<Point, Int>()
    values[Point(x: 0, y: 0)] = 1
    var result = 1
    let target = 277678
    
    func visit(x: Int, y: Int) {
        if x == 0 && y == 0 {
            return
        }

        var val = 0
        val += values[Point(x: x + 1, y: y + 1)] ?? 0
        val += values[Point(x: x,     y: y + 1)] ?? 0
        val += values[Point(x: x - 1, y: y + 1)] ?? 0
        val += values[Point(x: x + 1, y: y)] ?? 0
        val += values[Point(x: x - 1, y: y)] ?? 0
        val += values[Point(x: x + 1, y: y - 1)] ?? 0
        val += values[Point(x: x,     y: y - 1)] ?? 0
        val += values[Point(x: x - 1, y: y - 1)] ?? 0
        values[Point(x: x, y: y)] = val
        result = val
    }

    while true {
        for _ in 0..<map.step {
            map.right()
            visit(x: map.x, y: map.y)
            guard result <= target else { return result }
        }
        for _ in 0..<map.step {
            map.up()
            visit(x: map.x, y: map.y)
            guard result <= target else { return result }
        }
        map.step += 1
        for _ in 0..<map.step {
            map.left()
            visit(x: map.x, y: map.y)
            guard result <= target else { return result }
        }
        for _ in 0..<map.step {
            map.down()
            visit(x: map.x, y: map.y)
            guard result <= target else { return result }
        }
        map.step += 1
    }
    
    return 0
}
