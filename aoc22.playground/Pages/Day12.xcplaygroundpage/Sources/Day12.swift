import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    func manhattan(_ p: Point) -> Int {
        abs(p.x - x) + abs(p.y - y)
    }
    
    func neighbors() -> [Point] {
        return [
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y - 1),
            Point(x: x, y: y + 1),
        ]
    }
}

struct World {
    let world: Dictionary<Point, Int>
    let start: Point
    let goal: Point
}

func inputData() -> World {
    var world = Dictionary<Point, Int>()
    var start = Point(x: 0, y: 0)
    var goal = Point(x: 0, y: 0)
    var y = 0
    for line in stringsFromFile() where line != "" {
        var x = 0
        for ch in line {
            let p = Point(x: x, y: y)
            var value = Int(ch.asciiValue!) - 97
            if ch == "S" {
                start = p
                value = 0
            } else if ch == "E" {
                goal = p
                value = 25
            }
            world[p] = value
            x += 1
        }
        y += 1
    }
    return World(world: world, start: start, goal: goal)
}

func bfs(start: Point, goal: (Point) -> Bool, world: Dictionary<Point, Int>) -> [Point] {
    var queue = [Point]()
    queue.append(start)
    var cameFrom = Dictionary<Point, Point>()

    while !queue.isEmpty {
        let cur = queue.remove(at: 0)
        if goal(cur) {
            var result = [Point]()
            var prev: Point? = cur
            while prev != nil && prev != start {
                result.append(prev!)
                prev = cameFrom[prev!]
            }
            return result.reversed()
        }
        for n in cur.neighbors() where world[n] != nil && world[n]! <= world[cur]! + 1 {
            guard cameFrom[n] == nil else { continue }
            cameFrom[n] = cur
            queue.append(n)
        }
    }
    return []
}

public func part1() -> Int {
    let data = inputData()
    return bfs(start: data.start, goal: { $0 == data.goal }, world: data.world).count
}

public func part2() -> Int {
    let data = inputData()
    var result = Int.max
    for p in data.world where p.value == 0 {
        let steps = bfs(start: p.key, goal: { $0 == data.goal }, world: data.world).count
        if steps != 0 {
            result = min(result, steps)
        }
    }
    return result
}
