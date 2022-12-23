import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    func neighbors() -> [Point] {
        return [
            Point(x: x - 1, y: y - 1),
            Point(x: x   , y: y - 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x - 1, y: y + 1),
            Point(x: x,     y: y + 1),
            Point(x: x + 1, y: y + 1),
        ]
    }
    
    func look(_ check: Check) -> [Point] {
        switch check {
        case .north: return [Point(x: x - 1, y: y - 1), Point(x: x   , y: y - 1), Point(x: x + 1, y: y - 1)]
        case .south: return [Point(x: x - 1, y: y + 1), Point(x: x   , y: y + 1), Point(x: x + 1, y: y + 1)]
        case .west: return [Point(x: x - 1, y: y - 1), Point(x: x - 1, y: y), Point(x: x - 1, y: y + 1)]
        case .east: return [Point(x: x + 1, y: y - 1), Point(x: x + 1, y: y), Point(x: x + 1, y: y + 1)]
        }
    }
    
    func step(_ check: Check) -> Point {
        switch check {
        case .north: return Point(x: x, y: y - 1)
        case .south: return Point(x: x, y: y + 1)
        case .west: return Point(x: x - 1, y: y)
        case .east: return Point(x: x + 1, y: y)
        }
    }
}

enum Check {
    case north
    case south
    case west
    case east
}

func inputData() -> Set<Point> {
    var canvas = Set<Point>()
    var y = 0
    for line in stringsFromFile() where line != "" {
            var x = 0
            for ch in line {
                if ch == "#" {
                    canvas.insert(Point(x: x, y: y))
                }
                x += 1
            }
            y += 1
        }
    return canvas
}

func boundingBox(_ canvas: Set<Point>) -> (Point, Point) {
    var minX = Int.max
    var minY = Int.max
    var maxX = Int.min
    var maxY = Int.min
    for p in canvas {
        minX = min(minX, p.x)
        maxX = max(maxX, p.x)
        minY = min(minY, p.y)
        maxY = max(maxY, p.y)
    }
    return (Point(x: minX, y: minY), Point(x: maxX, y: maxY))
}

func show(_ canvas: Set<Point>) -> String {
    let bounds = boundingBox(canvas)
    var result = [Character]()
    for y in bounds.0.y...bounds.1.y {
        for x in bounds.0.x...bounds.1.x {
            let p = Point(x: x, y: y)
            result.append(canvas.contains(p) ? "#" : ".")
        }
        result.append("\n")
    }
    result.append("\n")
    return String(result)
}

public func part1() -> Int {
    var canvas = inputData()
    var checks: [Check] = [.north, .south, .west, .east]
    for _ in 1...10 {
        var newCanvas = Set<Point>()
        var proposed = Dictionary<Point, Set<Point>>()
        for e in canvas {
            if canvas.intersection(e.neighbors()).isEmpty {
                newCanvas.insert(e)
                continue
            }
            var stepped = false
            for check in checks {
                if Set(e.look(check)).intersection(canvas).isEmpty {
                    let step = e.step(check)
                    proposed[step] = proposed[step] ?? []
                    proposed[step]!.insert(e)
                    stepped = true
                    break
                }
            }
            if !stepped {
                newCanvas.insert(e)
            }
        }
        for (q, pp) in proposed {
            if pp.count == 1 {
                newCanvas.insert(q)
            } else {
                newCanvas.formUnion(pp)
            }
        }
        canvas = newCanvas
        checks.append(checks.remove(at: 0))
    }
    let bounds = boundingBox(canvas)
    return (bounds.1.x - bounds.0.x + 1) * (bounds.1.y - bounds.0.y + 1) - canvas.count
}

public func part2() -> Int {
    var canvas = inputData()
    var checks: [Check] = [.north, .south, .west, .east]
    for i in 1...100_000 {
        var newCanvas = Set<Point>()
        var proposed = Dictionary<Point, Set<Point>>()
        for e in canvas {
            if canvas.intersection(e.neighbors()).isEmpty {
                newCanvas.insert(e)
                continue
            }
            var stepped = false
            for check in checks {
                if Set(e.look(check)).intersection(canvas).isEmpty {
                    let step = e.step(check)
                    proposed[step] = proposed[step] ?? []
                    proposed[step]!.insert(e)
                    stepped = true
                    break
                }
            }
            if !stepped {
                newCanvas.insert(e)
            }
        }
        if newCanvas == canvas {
            return i
        }
        for (q, pp) in proposed {
            if pp.count == 1 {
                newCanvas.insert(q)
            } else {
                newCanvas.formUnion(pp)
            }
        }
        canvas = newCanvas
        checks.append(checks.remove(at: 0))
    }
    let bounds = boundingBox(canvas)
    return (bounds.1.x - bounds.0.x + 1) * (bounds.1.y - bounds.0.y + 1) - canvas.count
}
