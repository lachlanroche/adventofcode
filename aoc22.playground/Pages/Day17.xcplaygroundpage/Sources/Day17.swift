import Foundation

enum Shape: CaseIterable {
    case horizontal
    case plus
    case ell
    case vertical
    case square
}

enum Direction: Character {
    case right = ">"
    case left = "<"
}

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    var down: Point { Point(x: x, y: y - 1) }
    var left: Point { Point(x: x - 1, y: y) }
    var right: Point { Point(x: x + 1, y: y) }
}

struct Block {
    var coord: Point
    let shape: Shape
    
    var points: Set<Point> {
        let x = coord.x
        let y = coord.y
        switch shape {
        case .horizontal:
            return [Point(x: x, y: y), Point(x: x + 1, y: y), Point(x: x + 2, y: y), Point(x: x + 3, y: y)]
        case .plus:
            return [Point(x: x + 1, y: y), Point(x: x, y: y + 1), Point(x: x + 1, y: y + 1), Point(x: x + 2, y: y + 1), Point(x: x + 1, y: y + 2)]
        case .ell:
            return [Point(x: x, y: y), Point(x: x + 1, y: y), Point(x: x + 2, y: y), Point(x: x + 2, y: y + 1), Point(x: x + 2, y: y + 2)]
        case .vertical:
            return [Point(x: x, y: y), Point(x: x, y: y + 1), Point(x: x, y: y + 2), Point(x: x, y: y + 3)]
        case .square:
            return [Point(x: x, y: y), Point(x: x + 1, y: y), Point(x: x, y: y + 1), Point(x: x + 1, y: y + 1)]
        }
    }
    var down: Set<Point> {
        Set(points.map(\.down))
    }
    var left: Set<Point> {
        Set(points.map(\.left))
    }
    var right: Set<Point> {
        Set(points.map(\.right))
    }
    mutating func push(_ direction: Direction, in canvas: Set<Point>) {
        switch direction {
        case .left:
            let points = left
            if points.allSatisfy({ $0.x >= 0 }) && canvas.intersection(points).isEmpty {
                coord = coord.left
            }
        case .right:
            let points = right
            if points.allSatisfy({ $0.x <= 6 })  && canvas.intersection(points).isEmpty {
                coord = coord.right
            }
        }
    }
    mutating func fall(in canvas: Set<Point>) -> Bool {
        let points = down
        if points.allSatisfy({ $0.y >= 0 }) && canvas.intersection(points).isEmpty {
            coord = coord.down
            return true
        }
        return false
    }
}

func show(_ canvas: Set<Point>, _ block: Block) -> String {
    let maxY = canvas.union(block.points).reduce(0) { max($0, $1.y) }
    var result = [Character]()
    for y in (-1 * maxY)...0 {
        for x in 0...6 {
            let p = Point(x: x, y: -1 * y)
            if canvas.contains(p) {
                result.append("#")
            } else if block.points.contains(p) {
                result.append("@")
            } else {
                result.append(".")
            }
        }
        result.append("\n")
    }
    result.append("\n")
    return String(result)
}

public func part1() -> Int {
    let wind = stringsFromFile()[0].compactMap { Direction(rawValue: $0) }
    func shape(_ i: Int) -> Shape {
        Shape.allCases[i % 5]
    }
    var canvas = Set<Point>()
    var y = 3
    var w = 0
    for s in 0..<2022 {
        var block = Block(coord: Point(x: 2, y: y), shape: shape(s))
        while true {
            block.push(wind[w], in: canvas)
            w = (w + 1) % wind.count
            if !block.fall(in: canvas) {
                let points = block.points
                canvas.formUnion(points)
                y = 4 + canvas.reduce(0) { max($0, $1.y) }
                break
            }
        }
    }
    return 1 + canvas.reduce(0) { max($0, $1.y) }
}

