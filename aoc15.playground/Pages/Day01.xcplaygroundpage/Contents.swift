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

["(())", "()()", "(((", "(()(()(", "))(((((", "())", "))(", ")))", ")())())"].map(part1)

let url = Bundle.main.url(forResource: "input01", withExtension: "txt")
let data = try Data(contentsOf: url!)
part1(s: String(data: data, encoding: .utf8)!)

//: [Next](@next)
