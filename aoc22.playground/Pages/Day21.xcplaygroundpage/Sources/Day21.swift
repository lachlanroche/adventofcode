import Foundation

enum Monkey {
    case constant(Int)
    case equal(String, String)
    case add(String, String)
    case subtract(String, String)
    case multiply(String, String)
    case divide(String, String)
}

func inputData() -> [String: Monkey] {
    var results = [String: Monkey]()
    for line in stringsFromFile() where line != "" {
        let parts = line.replacingOccurrences(of: ": ", with: " ").split(separator: " ")
        let name = String(parts[0])
        if parts.count == 2 {
            results[name] = .constant(Int(parts[1])!)
        } else if parts[2] == "+" {
            results[name] = .add(String(parts[1]), String(parts[3]))
        } else if parts[2] == "-" {
            results[name] = .subtract(String(parts[1]), String(parts[3]))
        } else if parts[2] == "*" {
            results[name] = .multiply(String(parts[1]), String(parts[3]))
        } else if parts[2] == "/" {
            results[name] = .divide(String(parts[1]), String(parts[3]))
        }
    }
    return results
}


public func part1() -> Int {
    func monkey(_ id: String) -> Int {
        guard let chimp = monkeys[id] else { return 0 }
        switch chimp {
        case let .constant(c): return c
        case let .equal(a, b): return monkey(a) == monkey(b) ? 1 : 0
        case let .add(a, b): return monkey(a) + monkey(b)
        case let .subtract(a, b): return monkey(a) - monkey(b)
        case let .multiply(a, b): return monkey(a) * monkey(b)
        case let .divide(a, b): return monkey(a) / monkey(b)

        }
    }
    let monkeys = inputData()
    return monkey("root")
}

public func part2() -> Int {
    func monkey(_ id: String) -> Int {
        guard let chimp = monkeys[id] else { return 0 }
        switch chimp {
        case let .constant(c): return c
        case let .equal(a, b): return monkey(a) == monkey(b) ? 1 : 0
        case let .add(a, b): return monkey(a) + monkey(b)
        case let .subtract(a, b): return monkey(a) - monkey(b)
        case let .multiply(a, b): return monkey(a) * monkey(b)
        case let .divide(a, b): return monkey(a) / monkey(b)
        }
    }
    func show(_ id: String) -> String {
        guard let chimp = monkeys[id] else { return "" }
        if id == "humn" { return "x" }
        switch chimp {
        case let .constant(c): return String(c)
        case let .equal(a, b): return "(\(show(a))) = (\(show(b)))"
        case let .add(a, b): return "(\(show(a)) + \(show(b)))"
        case let .subtract(a, b): return "(\(show(a)) - \(show(b)))"
        case let .multiply(a, b): return "(\(show(a)) * \(show(b)))"
        case let .divide(a, b): return "(\(show(a)) / \(show(b)))"
        }
        
    }
    
    var monkeys = inputData()
    monkeys["root"] = .equal("qpct", "dthc")
    print(show("root"))
    return 0
}

public func part3() -> Int {
    func monkey(_ id: String) -> Int {
        guard let chimp = monkeys[id] else { return 0 }
        switch chimp {
        case let .constant(c): return c
        case let .equal(a, b): return monkey(a) == monkey(b) ? 1 : 0
        case let .add(a, b): return monkey(a) + monkey(b)
        case let .subtract(a, b): return monkey(a) - monkey(b)
        case let .multiply(a, b): return monkey(a) * monkey(b)
        case let .divide(a, b): return monkey(a) / monkey(b)
        }
    }
    var monkeys = inputData()
    monkeys["root"] = .equal("qpct", "dthc")
    monkeys["humn"] = .constant(3592056845086)
    return monkey("root")
}


