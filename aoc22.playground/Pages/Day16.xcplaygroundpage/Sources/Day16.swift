import Foundation

struct World {
    var flow = Dictionary<String, Int>()
    var edge = Dictionary<String, Set<String>>()
    var costs = Dictionary<String, [(String, Int)]>()
}

func inputData() -> World {
    var world = World()
    for line in stringsFromFile() where line != "" {
        let parts = line.replacingOccurrences(of: ", ", with: " ")
            .replacingOccurrences(of: "; ", with: " ")
            .replacingOccurrences(of: "=", with: " ")
            .split(separator: " ")
        let valve = String(parts[1])
        let flow = Int(parts[5])!
        let connections = parts.dropFirst(10).map { String($0) }
        if flow != 0 {
            world.flow[valve] = flow
        }
        for connection in connections {
            if nil == world.edge[valve] {
                world.edge[valve] = []
            }
            if nil == world.edge[connection] {
                world.edge[connection] = []
            }
            world.edge[valve]?.insert(connection)
            world.edge[connection]?.insert(valve)
        }
    }
    let nodes = Set(world.flow.keys)
    for n in nodes.union(["AA"]) {
        world.costs[n] = []
    }
    for e in nodes {
        var path = bfs(start: "AA", goal: e, world: world)
        if !path.isEmpty {
            world.costs["AA"]?.append((e, path.count))
        }
        for f in nodes where e != f {
            path = bfs(start: e, goal: f, world: world)
            if !path.isEmpty {
                world.costs[e]?.append((f, path.count))
            }
        }
    }
    return world
}

func bfs(start: String, goal: String, world: World) -> [String] {
    var queue = [String]()
    queue.append(start)
    var cameFrom = Dictionary<String, String>()

    while !queue.isEmpty {
        let cur = queue.remove(at: 0)
        if goal == cur {
            var result = [String]()
            var prev: String? = cur
            while prev != nil && prev != start {
                result.append(prev!)
                prev = cameFrom[prev!]
            }
            return result.reversed()
        }
        guard let neighbors = world.edge[cur] else { continue }
        for n in neighbors {
            guard cameFrom[n] == nil else { continue }
            cameFrom[n] = cur
            queue.append(n)
        }
    }
    return []
}

func search(_ world: World, _ seen: Set<String>, _ flow: Int, _ cur: String, _ timeLeft: Int, _ result: inout Int) {
    if flow > result {
        result = flow
    }
    if timeLeft <= 0 {
        return
    }
    if !seen.contains(cur) {
        search(world, seen.union([cur]), flow + world.flow[cur]! * timeLeft, cur, timeLeft - 1, &result)
    } else {
        for n in world.costs[cur]! where !seen.contains(n.0) {
            search(world, seen, flow, n.0, timeLeft - n.1, &result)
        }
    }
}

public func part1() -> Int {
    var result = 0
    search(inputData(), Set(["AA"]), 0, "AA", 29, &result)
    return result
}

func paths(_ world: World, _ path: [(String, Int)], _ cur: String, _ timeLeft: Int, _ result: inout [[(String, Int)]]) {
    if timeLeft <= 0 {
        result.append(path)
        return
    }
    if !path.contains(where: { $0.0 == cur }) {
        paths(world, path + [(cur, timeLeft)], cur, timeLeft - 1, &result)
    } else {
        for n in world.costs[cur]! where !path.contains(where: { $0.0 == n.0 }) {
            paths(world, path, n.0, timeLeft - n.1, &result)
        }
    }
}

struct Path: Equatable {
    let path: [String]
    let points: Set<String>
    let flow: Int
    
    init(path: [String], flow: Int) {
        self.path = path
        self.flow = flow
        points = Set(path)
    }
}

public func part2() -> Int {
    let world = inputData()
    var allPaths = [[(String, Int)]]()
    paths(world, [("AA", 0)], "AA", 25, &allPaths)
    var computed: [Path] = allPaths.map { p in
        Path(
            path: p.reduce(into: [String](), { if "AA" != $1.0 { $0.append($1.0) }}),
            flow: p.reduce(0, { $0 + $1.1 * (world.flow[$1.0] ?? 0) })
        )
    }
    var best = Dictionary<Set<String>, Path>()
    for p in computed {
        if let prev = best[p.points] {
            if p.flow > prev.flow {
                best[p.points] = p
            }
        } else {
            best[p.points] = p
        }
    }
    computed = best.values.sorted(by: { $0.flow < $1.flow })
    var result = -1
    for p in computed {
        for q in computed{
            guard p.points.intersection(q.points).isEmpty else { continue }
            result = max(result, q.flow + p.flow)
        }
    }
    return result
}
