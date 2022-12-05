import Foundation

public func part1() -> String {
    var stacks: [[Character]] = [
        [], [], [], [], [], [], [], [], []
    ]
    let cols = [1, 5, 9, 13, 17, 21, 25, 29, 33]
    for line in stringsFromFile() {
        guard line != "" else { continue }
        if line.hasPrefix("move") {
            let parts = line.split(separator: " ")
            let count = Int(parts[1])!
            let source = Int(parts[3])! - 1
            let destination = Int(parts[5])! - 1
            for _ in 1 ... count {
                if !stacks[source].isEmpty {
                    let value = stacks[source].removeLast()
                    stacks[destination].append(value)
                }
            }
        } else {
            let row = Array(line)
            for (i, col) in cols.enumerated() {
                if col < row.count && row[col].isLetter {
                    stacks[i].insert(row[col], at: 0)
                }
            }
        }
    }
    return String(stacks.compactMap { $0.last })
}

public func part2() -> String {
    var stacks: [[Character]] = [
        [], [], [], [], [], [], [], [], []
    ]
    let cols = [1, 5, 9, 13, 17, 21, 25, 29, 33]
    for line in stringsFromFile() {
        guard line != "" else { continue }
        if line.hasPrefix("move") {
            let parts = line.split(separator: " ")
            let count = Int(parts[1])!
            let source = Int(parts[3])! - 1
            let destination = Int(parts[5])! - 1
            let insertIndex = stacks[destination].endIndex
            for _ in 1 ... count {
                if !stacks[source].isEmpty {
                    let value = stacks[source].removeLast()
                    stacks[destination].insert(value, at: insertIndex)
                }
            }
        } else {
            let row = Array(line)
            for (i, col) in cols.enumerated() {
                if col < row.count && row[col].isLetter {
                    stacks[i].insert(row[col], at: 0)
                }
            }
        }
    }
    return String(stacks.compactMap { $0.last })
}
