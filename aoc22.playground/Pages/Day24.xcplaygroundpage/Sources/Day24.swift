import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    static let origin = Point(x: 0, y: 0)
    
    func manhattan(_ p: Point) -> Int {
        abs(p.x - x) + abs(p.y - y)
    }
    
    func neighbors() -> [Point] {
        return [
            self,
            Point(x: x,     y: y - 1),
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x,     y: y + 1),
        ]
    }
}

struct World {
    let start: Point
    let goal: Point
    let bound: Point
    var up: Set<Point>
    var down: Set<Point>
    var left: Set<Point>
    var right: Set<Point>
    
    func contains(_ p: Point) -> Bool {
        if p == goal || p == start {
            return true
        }
        if !(1...bound.x ~= p.x && 1...bound.y ~= p.y) {
            return false
        }
        return !(up.contains(p) || down.contains(p) || left.contains(p) || right.contains(p))
    }
    
    mutating func step() {
        up = Set(up.map({ p in
            p.y == 1 ? Point(x: p.x, y: bound.y) : Point(x: p.x, y: p.y - 1)
        }))
        down = Set(down.map({ p in
            p.y == bound.y ? Point(x: p.x, y: 1) : Point(x: p.x, y: p.y + 1)
        }))
        left = Set(left.map({ p in
            p.x == 1 ? Point(x: bound.x, y: p.y) : Point(x: p.x - 1, y: p.y)
        }))
        right = Set(right.map({ p in
            p.x == bound.x ? Point(x: 1, y: p.y) : Point(x: p.x + 1, y: p.y)
        }))
    }
    
    func show() -> String {
        var result = [Character]()
        for y in 0...(1 + bound.y) {
            for x in 0...(1 + bound.x) {
                let p = Point(x: x, y: y)
                if up.contains(p) {
                    result.append("^")
                } else if down.contains(p) {
                    result.append("v")
                } else if left.contains(p) {
                    result.append("<")
                } else if right.contains(p) {
                    result.append(">")
                } else if contains(p) {
                    result.append(".")
                } else {
                    result.append(" ")
                }
            }
            result.append("\n")
        }
        result.append("\n")
        return String(result)
    }
}

func inputData() -> World {
    var maxX = Int.min
    var maxY = Int.min
    var start = Point.origin
    var goal = Point.origin
    var up = Set<Point>()
    var down = Set<Point>()
    var left = Set<Point>()
    var right = Set<Point>()
    var y = 0
    for line in stringsFromFile() where line != "" {
        maxY = max(y, maxY)
        var x = 0
        for ch in line {
            maxX = max(x, maxX)
            let p = Point(x: x, y: y)
            switch ch {
            case ".":
                if y == 0 {
                    start = p
                }
                goal = p
            case "<":
                left.insert(p)
            case ">":
                right.insert(p)
            case "^":
                up.insert(p)
            case "v":
                down.insert(p)
            default:
                break
            }
            x += 1
        }
        y += 1
    }
    return World(
        start: start,
        goal: goal,
        bound: Point(x: maxX - 1, y: maxY - 1),
        up: up,
        down: down,
        left: left,
        right: right
    )
}

func bfs(world: World, traversals: Int) -> Int {
    var goal = world.goal
    var start = world.start
    var canvas = world
    var queue = [Point]()
    queue.append(start)
    var nextQueue = Set<Point>()
    var t = -1
    var traversal = 1
    
    while !(queue.isEmpty && nextQueue.isEmpty) {
        if queue.isEmpty {
            queue = Array(nextQueue.sorted(by: { world.goal.manhattan($0) < world.goal.manhattan($1)}).prefix(2000))
            nextQueue = []
            canvas.step()
            t += 1
        }
        let cur = queue.remove(at: 0)
        if goal == cur {
            if traversal == traversals {
                return t
            }
            if 0 == traversal % 2 {
                goal = world.goal
                start = world.start
            } else {
                goal = world.start
                start = world.goal
            }
            traversal += 1
            queue = []
            queue.append(start)
            nextQueue = []
            canvas.step()
            t += 1
        }
        for n in cur.neighbors() where canvas.contains(n) {
            nextQueue.insert(n)
        }
    }
    return -1
}

public func part1() -> Int {
    bfs(world: inputData(), traversals: 1)
}

public func part2() -> Int {
    bfs(world: inputData(), traversals: 3)
}
