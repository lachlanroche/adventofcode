import Foundation

public func part1() -> Int {
    let cc = numbersFromFile(named: "input")
    var acc = 0
    for sz in 1..<cc.count {
        let is150 = cc.combinations(taking: sz)
            .map{ c in c.reduce(0, +)}
            .filter{ $0 == 150 }
        acc += is150.count
    }
    return acc
}
