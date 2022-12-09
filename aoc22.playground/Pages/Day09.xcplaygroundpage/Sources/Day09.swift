import Foundation

enum Direction: String {
    case left = "L"
    case right = "R"
    case down = "D"
    case up = "U"
}

struct Point: Hashable, Equatable {
    var x: Int
    var y: Int
    
    mutating func step(_ direction: Direction) {
        switch direction {
        case .left:
            x -= 1
        case .right:
            x += 1
        case .down:
            y -= 1
        case .up:
            y += 1
        }
    }
    
    mutating func follow(_ p: Point) {
        let dx = p.x - x
        let dy = p.y - y
        guard abs(dx) > 1 || abs(dy) > 1 else { return }
        if dx == 0 {
            y = dy > 0 ? y + 1 : y - 1
        } else if dy == 0 {
            x = dx > 0 ? x + 1 : x - 1
        } else {
            x += (dx > 0) ? 1 : -1
            y += (dy > 0) ? 1 : -1
        }
    }
    
    func manhattan(_ p: Point) -> Int {
        return abs(x - p.x) + abs(y - p.y)
    }
}

public func part1() -> Int {
    var head = Point(x: 0, y: 0)
    var tail = Point(x: 0, y: 0)
    var visited = Set<Point>()
    visited.insert(tail)
    
    for line in stringsFromFile() {
        guard line != "" else { break }
        let parts = line.split(separator: " ")
        for _ in 0..<(Int(String(parts[1]))!) {
            head.step(Direction(rawValue: String(parts[0]))!)
            tail.follow(head)
            visited.insert(tail)
        }
    }
    
    return visited.count
}

public func part2() -> Int {
    var head = Point(x: 0, y: 0)
    var tails: [Point] = .init(repeating: Point(x: 0, y: 0), count: 9)
    var visited = Set<Point>()
    visited.insert(tails.last!)
    
    for line in stringsFromFile() {
        guard line != "" else { break }
        let parts = line.split(separator: " ")
        for _ in 0..<(Int(String(parts[1]))!) {
            head.step(Direction(rawValue: String(parts[0]))!)
            var prev = head
            for i in 0...8 {
                tails[i].follow(prev)
                prev = tails[i]
            }
            visited.insert(tails.last!)
        }
    }
    
    return visited.count
}
