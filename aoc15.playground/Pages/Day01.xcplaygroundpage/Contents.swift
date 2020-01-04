//: [Previous](@previous)

import Foundation

enum Direction: Character {
    case up = "("
    case down = ")"
}

func part1(s: String) -> Int {
    return s.reduce(0) { (acc, ch) in
        switch Direction(rawValue: ch) {
        case nil:
            return acc
        case .some(.up):
            return acc + 1
        case .some(.down):
            return acc - 1
        }
    }
}

func part2(s: String) -> Int {
    var floor = 0
    for (i, ch) in s.enumerated() {
        switch Direction(rawValue: ch) {
        case nil:
            continue
        case .some(.up):
            floor = floor + 1
            break
        case .some(.down):
            floor = floor - 1
            break
        }
        if floor == -1 {
            return i + 1
        }
    }
    return 0
}

["(())", "()()", "(((", "(()(()(", "))(((((", "())", "))(", ")))", ")())())"].map(part1)

let url = Bundle.main.url(forResource: "input01", withExtension: "txt")
let data = try Data(contentsOf: url!)
part1(s: String(data: data, encoding: .utf8)!)

[")", "()())"].map(part2)
part2(s: String(data: data, encoding: .utf8)!)

//: [Next](@next)
