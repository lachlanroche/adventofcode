import Foundation

struct Port: Hashable, Equatable, CustomStringConvertible {
    let a: Int
    let b: Int

    static var zero: Port { get { Port(a: 0, b: 0) } }
    func reversed() -> Port {
        return Port(a: b, b: a)
    }
    var description: String { get { "\(a)/\(b) " } }
}

func ports() -> Set<Port> {
    var result = Set<Port>()
    for s in stringsFromFile() {
        guard s.contains("/") else { continue }
        let parts = s.components(separatedBy: "/").map { Int($0)! }
        result.insert(Port(a: parts[0], b: parts[1]))
    }
    return result
}

func bridges(bridge: [Port], ports: Set<Port>) -> [[Port]] {
    var result = [[Port]]()
    let a = bridge.last!.b
    for p in ports.filter({ $0.a == a || $0.b == a }) {
        if !(bridge.contains(p) || bridge.contains(p.reversed())) {
            var pp = ports
            pp.remove(p)
            let q = (a == p.a) ? p : p.reversed()
            result = result + bridges(bridge: bridge + [q], ports: pp)
        }
    }
    return result.isEmpty ? [bridge] : result
}

public func part1() -> Int {
    var result = 0
    for b in bridges(bridge: [.zero], ports: ports()) {
        let score = b.reduce(0) { $0 + $1.a + $1.b}
        if score > result {
            result = score
        }
    }
    return result
}

