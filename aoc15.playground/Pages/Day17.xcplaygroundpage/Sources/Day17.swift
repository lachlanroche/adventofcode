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

public func part2() -> Int {
    let cc = numbersFromFile(named: "input")
    var best = Int.max
    var count = 0
    
    for sz in 1..<cc.count {
        cc.combinations(taking: sz)
            .forEach{ arr in
                let sum = arr.reduce(0, +)
                guard sum == 150 else { return }
                let size = arr.count
                if best == size {
                    count += 1
                } else if best > size {
                    best = size
                    count = 1
                }
            }
    }
    return count
}
