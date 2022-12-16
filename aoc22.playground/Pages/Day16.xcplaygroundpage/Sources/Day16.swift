import Foundation

struct World {
    var flow = Dictionary<String, Int>()
    var edge = Dictionary<String, Set<String>>()
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

public func part1() -> Int {
    let world = inputData()
    let nodes = Set(world.flow.keys)
    var costs = Dictionary<String, [(String, Int, Int)]>()
    for n in nodes.union(["AA"]) {
        costs[n] = []
    }
    for e in nodes {
        var path = bfs(start: "AA", goal: e, world: world)
        if !path.isEmpty {
            costs["AA"]?.append((e, path.count, world.flow[e]!))
        }
        for f in nodes where e != f {
            path = bfs(start: e, goal: f, world: world)
            if !path.isEmpty {
                costs[e]?.append((f, path.count, world.flow[f]!))
            }
        }
    }
    
    func search(_ seen: Set<String>, _ flow: Int, _ cur: String, _ timeLeft: Int, _ result: inout Int) {
        if flow > result {
            result = flow
        }
        if timeLeft <= 0 {
            return
        }
        if !seen.contains(cur) {
            search(seen.union([cur]), flow + world.flow[cur]! * timeLeft, cur, timeLeft - 1, &result)
        } else {
            for n in costs[cur]! where !seen.contains(n.0) {
                search(seen, flow, n.0, timeLeft - n.1, &result)
            }
        }
    }
    
    var result = 0
    search(Set(["AA"]), 0, "AA", 29, &result)
    return result
}
