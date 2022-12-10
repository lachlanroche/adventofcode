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
    
    mutating func step(_ direction: Direction) {
        switch direction {
        case .left:
            x -= 1
            x = max(x, -1)
        case .right:
            x += 1
            x = min(x, 1)
        case .down:
            y -= 1
            y = max(y, -1)
        case .up:
            y += 1
            y = min(y, 1)
        }
    }
    
    var value: Character {
        switch (x, y) {
        case (-1,  1): return "1"
        case ( 0,  1): return "2"
        case ( 1,  1): return "3"
        case (-1,  0): return "4"
        case ( 0,  0): return "5"
        case ( 1,  0): return "6"
        case (-1, -1): return "7"
        case ( 0, -1): return "8"
        case ( 1, -1): return "9"
        default: return "X"
        }
    }
    
    static var origin = Point(x: 0, y: 0)
}

public func part1() -> String {
    var p = Point.origin
    var result = [Character]()
    for line in stringsFromFile() {
        guard line != "" else { break }
        for c in line {
            p.step(Direction(rawValue:c)!)
        }
        result.append(p.value)
    }
    return String(result)
}

struct Point2: Hashable, Equatable {
    var x: Int
    var y: Int
    
    mutating func step(_ direction: Direction) {
        switch direction {
        case .left:
            if !"125AD".contains(value) {
                x -= 1
            }
        case .right:
            if !"149CD".contains(value) {
                x += 1
            }
        case .down:
            if !"5ADC9".contains(value) {
                y -= 1
            }
        case .up:
            if !"52149".contains(value) {
                y += 1
            }
        }
    }
    
    var value: Character {
        switch (x, y) {
        case ( 0,  2): return "1"
        case (-1,  1): return "2"
        case ( 0,  1): return "3"
        case ( 1,  1): return "4"
        case (-2,  0): return "5"
        case (-1,  0): return "6"
        case ( 0,  0): return "7"
        case ( 1,  0): return "8"
        case ( 2,  0): return "9"
        case (-1, -1): return "A"
        case ( 0, -1): return "B"
        case ( 1, -1): return "C"
        case ( 0, -2): return "D"
        default: return "X"
        }
    }
    
    static var origin = Point2(x: -2, y: 0)
}

public func part2() -> String {
    var p = Point2.origin
    var result = [Character]()
    for line in stringsFromFile() {
        guard line != "" else { break }
        for c in line {
            p.step(Direction(rawValue:c)!)
        }
        result.append(p.value)
    }
    return String(result)
}
