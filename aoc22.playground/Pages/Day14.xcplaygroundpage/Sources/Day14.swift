import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
}

func inputData() -> [[Point]] {
    var result = [[Point]]()
    for line in stringsFromFile() where line != "" {
        var row = [Point]()
        for coord in line.components(separatedBy: " -> ") {
            let xy = coord.split(separator: ",").map { Int($0)! }
            row.append(Point(x: xy[0], y: xy[1]))
        }
        result.append(row)
    }
    return result
}

func boundingBox(_ canvas: Dictionary<Point, Character>) -> (Point, Point) {
    var maxX = Int.min
    var maxY = Int.min
    var minX = Int.max
    var minY = Int.max
    for k in canvas.keys {
        maxX = max(maxX, k.x)
        maxY = max(maxY, k.y)
        minX = min(minX, k.x)
        minY = min(minY, k.y)
    }
    return (Point(x: minX, y: minY), Point(x: maxX, y: maxY))
}

func makeCanvas(_ lines: [[Point]]) -> Dictionary<Point, Character> {
    var canvas = Dictionary<Point, Character>()
    for line in lines {
        for i in 1..<line.count {
            let p1 = line[i-1]
            let p2 = line[i]
            
            if p1.x == p2.x {
                let yy = [p1.y, p2.y].sorted()
                for y in yy[0]...yy[1] {
                    let q = Point(x: p1.x, y: y)
                    canvas[q] = "#"
                }
            } else {
                let xx = [p1.x, p2.x].sorted()
                for x in xx[0]...xx[1] {
                    let q = Point(x: x, y: p1.y)
                    canvas[q] = "#"
                }
            }
        }
    }
    return canvas
}

func canvasAsString(_ canvas: Dictionary<Point, Character>) -> String {
    var result = [Character]()
    let bounds = boundingBox(canvas)
    for y in (bounds.0.y - 1)...(bounds.1.y + 1) {
        for x in (bounds.0.x - 1)...(bounds.1.x + 1) {
            if let ch = canvas[Point(x: x, y: y)] {
                result.append(ch)
            } else {
                result.append(".")
            }
        }
        result.append("\n")
    }
    return String(result)
}

func dropSand(at point: Point, maxY: Int, in canvas: inout Dictionary<Point, Character>) -> Bool {
    var p = point
    while true {
        var q = Point(x: p.x, y: p.y + 1)
        if q.y >= maxY {
            return false
        }
        if canvas[q] == nil {
            p = q
            continue
        }
        q = Point(x: p.x - 1, y: p.y + 1)
        if canvas[q] == nil {
            p = q
            continue
        }
        q = Point(x: p.x + 1, y: p.y + 1)
        if canvas[q] == nil {
            p = q
            continue
        }
        canvas[p] = "o"
        return true
    }
}

public func part1() -> Int {
    var canvas = makeCanvas(inputData())
    let bounds = boundingBox(canvas)
    var result = 0
    while dropSand(at: Point(x: 500, y: 0), maxY: bounds.1.y + 2, in: &canvas) {
        result += 1
    }
    return result
}

public func part2() -> Int {
    var canvas = makeCanvas(inputData())
    let bounds = boundingBox(canvas)
    for x in -1000...1000 {
        let q = Point(x: x, y: bounds.1.y + 2)
        canvas[q] = "#"
    }
    let origin = Point(x: 500, y: 0)
    var result = 0
    while nil == canvas[origin] {
        _ = dropSand(at: origin, maxY: bounds.1.y + 3, in: &canvas)
        result += 1
    }
    return result
}
