import Foundation

func importData() -> Dictionary<Point, Infection> {
    var result = Dictionary<Point, Infection>()
    var x = -12
    var y = -12
    for s in stringsFromFile(named: "input") {
        if s == "" {
            break
        }
        for c in s {
            if c == "#" {
                result[Point(x: x, y: y)] = .infected
            }
            x += 1
        }
        y += 1
        x = -12
    }
    
    return result
}

enum Infection {
    case weakened
    case infected
    case flagged
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

enum Direction {
    case down
    case up
    case left
    case right
}

extension Direction {
    func turnLeft() -> Direction {
        switch self {
            case .up: return .left
            case .left: return .down
            case .down: return .right
            case .right: return .up
        }
    }
    func turnRight() -> Direction {
        switch self {
            case .up: return .right
            case .right: return .down
            case .down: return .left
            case .left: return .up
        }
    }
}

extension Point {
    func step(_ direction: Direction) -> Point {
        switch direction {
            case .down:
                return Point(x: x, y: y + 1)
            case .up:
                return Point(x: x, y: y - 1)
            case .right:
                return Point(x: x + 1, y: y)
            case .left:
                return Point(x: x - 1, y: y)
        }
    }
}

public func part1() -> Int {
    var world = importData()
    var position = Point(x: 0, y: 0)
    var direction = Direction.up
    var infections = 0
    
    for _ in 1..<10000 {
        
        if let _ = world[position] {
            direction = direction.turnRight()
            world.removeValue(forKey: position)
        } else {
            direction = direction.turnLeft()
            world[position] = .infected
            infections += 1
        }
        position = position.step(direction)
    }
    
    return infections
}
