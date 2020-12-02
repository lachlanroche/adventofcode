import Foundation


func inputData() -> [Int] {
    return stringsFromFile(named: "input")
        .compactMap{ Int($0) }
}

public func part1() -> Int {
    var ram = inputData()
    var pc = 0
    var i = 0
    while true {
        guard pc >= 0 else { return i }
        guard pc < ram.count else { return i }
        let delta = ram[pc]
        ram[pc] += 1
        pc += delta
        i += 1
    }
}

public func part2() -> Int {
    var ram = inputData()
    var pc = 0
    var i = 0
    while true {
        guard pc >= 0 else { return i }
        guard pc < ram.count else { return i }
        let delta = ram[pc]
        if delta >= 3 {
            ram[pc] -= 1
        } else {
            ram[pc] += 1
        }
        pc += delta
        i += 1
    }
}
