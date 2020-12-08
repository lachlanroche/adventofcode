import Foundation


public func part1() -> Int {
    let qe = numbersFromFile(named: "input")
        .combinations(taking: 6)
        .filter{ 516 == $0.reduce(0, +)}
        .map{ $0.reduce(1, *)}

    return qe.first!
}

