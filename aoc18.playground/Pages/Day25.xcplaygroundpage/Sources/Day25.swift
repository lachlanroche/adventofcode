import Foundation

struct Point: Equatable, Hashable {
    let a: Int
    let b: Int
    let c: Int
    let d: Int
    
    init?(_ abcd: [Int]) {
        guard abcd.count == 4 else { return nil }
        a = abcd[0]
        b = abcd[1]
        c = abcd[2]
        d = abcd[3]
    }

    func manhattan(_ p: Point) -> Int {
        return abs(a - p.a) + abs(b - p.b) + abs(c - p.c) + abs(d - p.d)
    }
}

public func part1() -> Int {
    var world = Set<Point>()
    for line in stringsFromFile() {
        guard line != "" else { break }
        if let p = Point(line.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces)}).compactMap { Int(String($0)) }) {
            world.insert(p)
        }
    }
    
    var adjacent = Dictionary<Point,Set<Point>>()
    for p in world {
        adjacent[p] = []
        for q in world {
            guard p.manhattan(q) <= 3 else { continue }
            adjacent[p]?.insert(q)
        }
    }
    
    var result = 0
    for p in world {
        guard let neighbors = adjacent[p] else { continue }
        result += 1
        var candidates = neighbors
        adjacent.removeValue(forKey: p)
        while !candidates.isEmpty {
            let q = candidates.removeFirst()
            guard let more = adjacent[q] else  { continue }
            adjacent.removeValue(forKey: q)
            candidates.formUnion(more)
        }
    }
    
    return result
}
