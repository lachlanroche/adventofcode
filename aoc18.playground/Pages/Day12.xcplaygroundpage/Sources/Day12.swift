import Foundation

func inputData() -> (Set<Int>, Array<[Character]>) {
    var initial = Set<Int>()
    var rules = Array<[Character]>()
    
    for s in stringsFromFile() {
        if s.hasPrefix("initial") {
            let i = s.dropFirst(15).enumerated().filter { $1 == "#" }.map { $0.offset }
            initial = Set(i)
            
        } else if s.hasSuffix(" => #") {
            let r = s.prefix(5)
            rules.append(Array(r))
        }
    }
    
    return (initial, rules)
}

func generate(world: Set<Int>, rules: Array<[Character]>) -> Set<Int> {
    guard let min = world.min(), let max = world.max() else {
        return world
    }
    var result = Set<Int>()
    
    for i in (min - 3)...(max + 3) {
        let pattern = [-2, -1, 0, 1, 2].map { Character(world.contains(i + $0) ? "#" : ".") }
        if rules.contains(pattern) {
            result.insert(i)
        }
    }
    
    return result
}

public func part1() -> Int {
    let data = inputData()
    var world = data.0
    
    for _ in 0..<20 {
        world = generate(world: world, rules: data.1)
    }
    
    return world.reduce(0, +)
}

