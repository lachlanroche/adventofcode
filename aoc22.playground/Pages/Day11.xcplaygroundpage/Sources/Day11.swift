import Foundation

enum Operation {
    case plus
    case multiply
    case square
    
    func apply(worry: Int, constant: Int) -> Int {
        switch self {
        case .plus:
            return worry + constant
        case .multiply:
            return worry * constant
        case .square:
            return worry * worry
        }
    }
}

struct Monkey {
    let id: Int
    var items: [Int]
    let op: Operation
    let constant: Int
    let divisible: Int
    let ifTrue: Int
    let ifFalse: Int
    var inspections = 0
}

public func part1() -> Int {
    var monkeys = [Monkey]()
    var id = 0
    var items = [Int]()
    var op = Operation.plus
    var constant = 0
    var divisible = 0
    var ifTrue = 0
    var ifFalse = 0
    for line in stringsFromFile() {
        if line.hasPrefix("Monkey ") {
            id = Int(line.replacingOccurrences(of: ":", with: "").split(separator: " ").last!)!
        } else if line.hasPrefix("  Starting items:") {
            items = line.replacingOccurrences(of: ", ", with: " ").split(separator: " ").dropFirst(2).compactMap { Int($0)! }
        } else if line.hasPrefix("  Operation") {
            if line.contains("old * old") {
                op = .square
                constant = 1
            } else {
                constant = Int(line.split(separator: " ").last!)!
                op = line.contains("old + ") ? .plus : .multiply
            }
        } else if line.hasPrefix("  Test") {
            divisible = Int(line.split(separator: " ").last!)!
        } else if line.hasPrefix("    If true") {
            ifTrue = Int(line.split(separator: " ").last!)!
        } else if line.hasPrefix("    If false") {
            ifFalse = Int(line.split(separator: " ").last!)!
            monkeys.append(Monkey(id: id, items: items, op: op, constant: constant, divisible: divisible, ifTrue: ifTrue, ifFalse: ifFalse))
        }
    }
    
    func inspect(monkey id: Int) {
        let items = monkeys[id].items
        monkeys[id].items = []
        for item in items {
            var worry = item
            worry = monkeys[id].op.apply(worry: worry, constant: monkeys[id].constant)
            worry /= 3
            if worry % monkeys[id].divisible == 0 {
                monkeys[monkeys[id].ifTrue].items.append(worry)
            } else {
                monkeys[monkeys[id].ifFalse].items.append(worry)
            }
            monkeys[id].inspections += 1
        }
    }
    
    for _ in 0..<20 {
        for i in 0..<(monkeys.count) {
            inspect(monkey: i)
        }
    }
    
    monkeys.sort { $0.inspections > $1.inspections }
    
    return monkeys[0].inspections * monkeys[1].inspections
}

public func part2() -> Int {
    0
}
