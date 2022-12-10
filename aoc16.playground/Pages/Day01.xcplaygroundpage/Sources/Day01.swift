import Foundation

enum Direction: Character {
    case left = "L"
    case right = "R"
    case down = "D"
    case up = "U"
}

struct Point: Hashable, Equatable {
    var x: Int
    var y: Int
    var direction: Direction = .up
    
    mutating func step() {
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
    
    mutating func turn(_ turn: Direction) {
        switch (direction, turn) {
        case (.up, .left): direction = .left
        case (.left, .left): direction = .down
        case (.down, .left): direction = .right
        case (.right, .left): direction = .up
        case (.up, .right): direction = .right
        case (.right, .right): direction = .down
        case (.down, .right): direction = .left
        case (.left, .right): direction = .up
        default: break
        }
    }
    
    static var origin = Point(x: 0, y: 0)
    
    func manhattan(_ p: Point) -> Int {
        return abs(x - p.x) + abs(y - p.y)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        [x, y].hash(into: &hasher)
    }
}

public func part1() -> Int {
    var p = Point.origin
    for line in stringsFromFile() {
        guard line != "" else { break }
        line.components(separatedBy: ", ").forEach {
            p.turn(Direction(rawValue: $0[0])!)
            for _ in 0..<(Int($0.substring(fromIndex: 1))!) {
                p.step()
            }
        }
    }
    return p.manhattan(.origin)
}

public func part2() -> Int {
    var seen = Set<Point>()
    var p = Point.origin
    seen.insert(p)
    for line in stringsFromFile() {
        guard line != "" else { break }
        for part in line.components(separatedBy: ", ") {
            p.turn(Direction(rawValue: part[0])!)
            for _ in 0..<(Int(part.substring(fromIndex: 1))!) {
                p.step()
                if seen.contains(p) {
                    return p.manhattan(.origin)
                }
                seen.insert(p)
            }
        }
    }
    return 0
}
