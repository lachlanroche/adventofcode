import Foundation

func importData() -> Dictionary<Point, Character> {
    var result = Dictionary<Point, Character>()
    var x = 0
    var y = 0
    for s in stringsFromFile(named: "input") {
        if s == "" {
            break
        }
        for c in s {
            if c != " " {
                result[Point(x: x, y: y)] = c
            }
            x += 1
        }
        y += 1
        x = 0
    }
    
    return result
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


public func walk() -> (word: String, steps: Int) {
    let world = importData()
    var position = world.keys.filter{ $0.y == 0 }.first!
    var result = Array<Character>()
    var direction = Direction.down
    var steps = 0
    
    while true {
        guard let c = world[position] else { break }
        if c.isLetter {
            result.append(c)
        }
        if c == "+" {
            switch direction {
            case .up:
                fallthrough
            case .down:
                if let _ = world[position.step(.left)] {
                    direction = .left
                } else {
                    direction = .right
                }
                break
            case .left:
                fallthrough
            case .right:
                if let _ = world[position.step(.up)] {
                    direction = .up
                } else {
                    direction = .down
                }
                break
            }
        }
        position = position.step(direction)
        steps += 1
    }
    
    return (String(result), steps)
}

public func part1() -> String {
    return walk().word
}

public func part2() -> Int {
    return walk().steps
}
