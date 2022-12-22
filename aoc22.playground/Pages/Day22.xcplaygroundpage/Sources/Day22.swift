import Foundation

enum Move {
    case walk(Int)
    case left
    case right
}

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    static var origin = Point(x: 1, y: 1)
}


enum Direction: Int {
    case left = 2
    case right = 0
    case up = 3
    case down = 1

    var character: Character {
        switch self {
        case .left: return "<"
        case .right: return ">"
        case .up: return "^"
        case .down: return "v"
        }
    }

    func turn(_ direction: Direction) -> Direction {
        switch (direction, self) {
        case (.left, .left): return .down
        case (.left, .down): return .right
        case (.left, .right): return .up
        case (.left, .up): return .left
        case (.right, .right): return .down
        case (.right, .down): return .left
        case (.right, .left): return .up
        case (.right, .up): return .right
        default: return self
        }
    }
}

func inputData(start: inout Point) -> (Dictionary<Point, Character>, [Move]) {
    var canvas = Dictionary<Point, Character>()
    var moves = [Move]()
    var y = 1
    for line in stringsFromFile() where line != "" {
        if line.first!.isLetter || line.first!.isNumber {
            var buffer = [Character]()
            for ch in line {
                if ch == "L" || ch == "R" {
                    if !buffer.isEmpty {
                        moves.append(.walk(Int(String(buffer))!))
                        buffer = []
                    }
                    if ch == "L" {
                        moves.append(.left)
                    } else {
                        moves.append(.right)
                    }
                } else {
                    buffer.append(ch)
                }
            }
            if !buffer.isEmpty {
                moves.append(.walk(Int(String(buffer))!))
            }
        } else {
            var x = 1
            for ch in line {
                if ch == "#" || ch == "." {
                    let p = Point(x: x, y: y)
                    if start == Point.origin {
                        start = p
                    }
                    canvas[p] = ch
                }
                x += 1
            }
            y += 1
        }
    }
    return (canvas, moves)
}

extension Point {
    func step(_ direction: Direction, in canvas: Dictionary<Point, Character>) -> Point {
        var dx = 0
        var dy = 0
        switch direction {
        case .left: dx = -1
        case .right: dx = 1
        case .up: dy = -1
        case .down: dy = 1
        }
        var p = Point(x: x + dx, y: y + dy)
        if nil != canvas[p] {
            return p
        }
        p = self
        for _ in 1...100_000 {
            let q = Point(x: p.x - dx, y: p.y - dy)
            if nil == canvas[q] {
                return p
            }
            p = q
        }
        return Point.origin
    }
}

func boundingBox(_ canvas: Dictionary<Point, Character>) -> (Point, Point) {
    var minX = Int.max
    var minY = Int.max
    var maxX = Int.min
    var maxY = Int.min
    for p in canvas.keys {
        minX = min(minX, p.x)
        maxX = max(maxX, p.x)
        minY = min(minY, p.y)
        maxY = max(maxY, p.y)
    }
    return (Point(x: minX, y: minY), Point(x: maxX, y: maxY))
}

func show(_ canvas: Dictionary<Point, Character>) -> String {
    let bounds = boundingBox(canvas)
    var result = [Character]()
    for y in bounds.0.y...bounds.1.y {
        for x in bounds.0.x...bounds.1.x {
            result.append(canvas[Point(x: x, y: y)] ?? " ")
        }
        result.append("\n")
    }
    return String(result)
}

public func part1() -> Int {
    var point = Point.origin
    var direction = Direction.right
    var (canvas, moves) = inputData(start: &point)
    for move in moves {
        canvas[point] = direction.character
        switch move {
        case .left:
            direction = direction.turn(.left)
        case .right:
            direction = direction.turn(.right)
        case let .walk(steps):
            for _ in 0..<steps {
                let next = point.step(direction, in: canvas)
                canvas[point] = direction.character
                if canvas[next] == "#" {
                    break
                }
                point = next
            }
        }
    }
    return point.x * 4 + point.y * 1000 + direction.rawValue
}

