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

