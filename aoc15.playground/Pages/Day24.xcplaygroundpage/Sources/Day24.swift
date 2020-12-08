import Foundation


public func part1() -> Int {
    let qe = numbersFromFile(named: "input")
        .combinations(taking: 6)
        .filter{ 516 == $0.reduce(0, +)}
        .map{ $0.reduce(1, *)}

    return qe.first!
}

public func part2() -> Int {
    let numbers = numbersFromFile(named: "input")
    let total = numbers.reduce(0, +)
    
    let qe = numbers
        .combinations(taking: 5)
        .filter{ (total/4) == $0.reduce(0, +)}
        .map{ $0.reduce(1, *)}
    
    return qe.first!
}

