import Foundation
import aoc22_Sources


public func part1() -> Int {
    var most = 0
    var current = 0
    for line in stringsFromFile() {
        if line == "" {
            most = max(most, current)
            current = 0
        } else if let number = Int(line) {
            current += number
        }
    }
    return most
}
