import Foundation

public func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input09", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

func inputData() -> Graph {
    var graph = Graph()

    for s in inputstring().components(separatedBy: "\n") {
        let str = s.components(separatedBy: " ")
        guard str.count == 5 else { continue }
        graph.addEdge(from: str[0], to: str[2], cost: Int(str[4])!)
    }
    
    return graph
}

public
struct Graph {
    var edges: Dictionary<Set<String>,Int> = [:]
}

typealias Edge = (key: Set<String>, value: Int)

public
extension Graph {
    
    var nodes: [String] {
        get {
            let nodes = edges.keys.reduce(into: Set<String>()) {
                (acc, edge) in
                acc.formUnion(edge)
            }
            return Array(nodes)
        }
    }
    
    func neighbors(of node: String) -> [String] {
        let nodes = edges.reduce(into: Set<String>()) {
            (acc, edge) in
            if edge.key.contains(node) {
                acc.formUnion(edge.key)
            }
        }
        
        return Array(nodes.subtracting([node]))
    }
    
    func cost(from: String, to: String) -> Int? {
        return edges[[from, to]]
    }

    mutating func addEdge(from: String, to: String, cost: Int) {
        let edge: Set<String> = [from, to]
        edges[edge] = cost
    }
    
    func pathDistance(path: [String]) -> Int {
        var prev = ""
        var pathCost = 0
        
        for node in path {
            if let cost = cost(from: prev, to: node) {
                pathCost = pathCost + cost
            }
            prev = node
        }
        
        return pathCost
    }
    
    typealias PathAndDistance = (path: [String], cost: Int)
    
    func shortestPathAndDistance() -> PathAndDistance {
        return allPaths().reduce(allPaths().first!) {
            (result, path) in
            return (path.cost < result.cost) ? path : result
        }
    }
    
    func allPaths() -> [PathAndDistance] {
        return permutations(of: Set(nodes)).map { ($0, pathDistance(path: $0)) }
    }
}

public
func permutations(of nodes: Set<String>) -> [[String]] {
    if nodes.isEmpty {
        return []
    }
    if nodes.count == 1 {
        return [[nodes.first!]]
    }
    
    return nodes.reduce(into: []) {
        (result, node) in

        for tail in permutations(of: nodes.subtracting([node])) {
            result.append([node] + tail)
        }
    }
}

public func part1() -> Int {
    let path = inputData().shortestPathAndDistance()
    return path.cost
}
