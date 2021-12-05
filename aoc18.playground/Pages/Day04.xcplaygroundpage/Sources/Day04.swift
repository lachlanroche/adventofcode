import Foundation

struct Guard: Hashable {
    let id: Int
    let minute: Int
}

func sleep(from: String, to: String) -> [Int] {
    let f = Int(from.components(separatedBy: ":")[1])!
    let t = Int(to.components(separatedBy: ":")[1])!
    
    return Array(f..<t)
}

public func part1() -> Int {
    var inputData = stringsFromFile().filter { "" != $0 }.sorted()
    var guards = Dictionary<Guard, Int>()
    var guardsTotal = Dictionary<Int,Int>()
    
    func wasAsleep(sleepStop: String) {
        for m in sleep(from: sleepStart, to: sleepStop) {
            let g = Guard(id: id, minute: m)
            guards[g] = 1 + (guards[g] ?? 0)
            guardsTotal[id] = 1 + (guardsTotal[id] ?? 0)
        }
    }
    
    var id = 0
    var asleep = false
    var sleepStart = ""
    for e in inputData {
        let d = e[1..<17]
        if e.hasSuffix("wakes up") {
            wasAsleep(sleepStop: d)
            asleep = false
            
        } else if e.hasSuffix("falls asleep") {
            asleep = true
            sleepStart = d
            
        } else if e.hasSuffix("begins shift") {
            if asleep {
                wasAsleep(sleepStop: d)
            }
            asleep = false
            id = Int(e.components(separatedBy: "#")[1].split(separator: " ")[0])!
        }
    }

    let gid = guardsTotal.enumerated().sorted(by: {$0.element.value > $1.element.value}).map { $0.element.key }[0]
    
    return guards.enumerated().filter { $0.element.key.id == gid }.sorted(by: { $0.element.value > $1.element.value }).map { $0.element.key.id * $0.element.key.minute }[0] ?? 0
}

