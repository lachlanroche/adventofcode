import Foundation

struct Point2D: Hashable, Equatable {
    let x: Int
    let y: Int
    
    func manhattan(_ p: Point2D) -> Int {
        return abs(p.x - x) + abs (p.y - y)
    }
    
    func neighbors() -> [Point2D] {
        return [
            Point2D(x: x - 1, y: y),
            Point2D(x: x + 1, y: y),
            Point2D(x: x, y: y - 1),
            Point2D(x: x, y: y + 1),
        ]
    }
}

func inputData() -> Dictionary<Point2D,Int> {
    var result = Dictionary<Point2D,Int>()
    var y = 0
    for str in stringsFromFile() {
        guard str != "" else { continue }
        var x = 0
        for c in str {
            let p = Point2D(x: x, y: y)
            let v = Int(c.asciiValue!) - 48
            result[p] = v
            x = 1 + x
        }
        y = 1 + y
    }
    return result
}

func astar(start: Point2D, goal: Point2D, world: Dictionary<Point2D,Int>) -> [Point2D] {
    
    func reconstruct(pathTo: Point2D) -> [Point2D] {
        var current = pathTo
        var result = [current]
        while let next = cameFrom[current] {
            result.insert(next, at: 0)
            current = next
        }
        return result
    }
    
    var openSet: PriorityQueue<Point2D> = .minQueue
    var cameFrom = Dictionary<Point2D, Point2D>()
    var gScore = [Point2D:Int]()
    gScore[start] = 0
    var fScore = [Point2D:Int]()
    fScore[start] = 0
    openSet.enqueue(start, withPriority: Double(fScore[start]!))

    while let cur = openSet.dequeue() {
        if cur == goal {
            return reconstruct(pathTo: cur)
        }
        
        for n in cur.neighbors() {
            let tentativeGScore = gScore[cur]! + world[n, default: 1_000_000_000]
            if tentativeGScore < gScore[n, default: 1_000_000_000] && nil != world[n] {
                cameFrom[n] = cur
                gScore[n] = tentativeGScore
                fScore[n] = tentativeGScore + cur.manhattan(goal)
                openSet.enqueue(n, withPriority: Double(fScore[n]!))
            }
        }
    }
    
    return []
}

public func part1() -> Int {
    let world = inputData()
    let start = Point2D(x: 0, y: 0)
    let goal = Point2D(x: 99, y: 99)
    let result = astar(start: start, goal: goal, world: world)
    return result.reduce(-1) { $0 + world[$1]! }
}

