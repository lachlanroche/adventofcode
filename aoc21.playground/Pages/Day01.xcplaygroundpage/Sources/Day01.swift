import Foundation

let data = numbersFromFile(named: "input")

public func part1() -> Int {
    var count = 0
    var prev = data[0]
    for n in data {
        if n > prev {
            count = 1 + count
        }
        prev = n
    }
    return count
}

public func part2() -> Int {
    var prev = 1_000_000
    var count = 0
    for ds in data.windows(ofCount:3) {
        let dss = ds.reduce(0, +)
        if dss > prev {
            count = 1 + count
        }
        prev = dss
    }
    return count
}
