//: [Previous](@previous)

import Foundation

enum Direction: Character {
    case up = "^"
    case right = ">"
    case down = "v"
    case left = "<"
}

func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input03", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

func inputdata() -> [Direction]
{
    return inputstring().directions()
}

extension String {
    func directions() -> [Direction] {
        return self.reduce(into: []) { (acc, ch) in
            guard let dir = Direction(rawValue: ch) else { return }
            acc.append(dir)
        }
    }
}

struct Point: Hashable {
    var x, y: Int
}

extension Point {
    static var zero: Point {
        get {
            return Point(x: 0, y: 0)
        }
    }
    
    func step(direction: Direction) -> Point {
        switch direction {
        case .up:
            return Point(x: x - 1, y: y)
        case .down:
            return Point(x: x + 1, y: y)
        case .right:
            return Point(x: x, y: y + 1)
        case .left:
            return Point(x: x, y: y - 1)
        }
    }
}

func howManyHouses(directions: [Direction]) -> Int {
    var visited: Set<Point> = [.zero]

    directions.reduce(Point.zero) { (position, dir) in
        let nextPos = position.step(direction: dir)
        visited.insert(nextPos)
        return nextPos
    }
    
    
    return visited.count
}

func part1() -> Int {
    return howManyHouses(directions: inputdata())
}

//howManyHouses(directions: ">".directions())
//howManyHouses(directions: "^>v<".directions())
//howManyHouses(directions: "^v^v^v^v^v".directions())
//part1()

//: [Next](@next)
