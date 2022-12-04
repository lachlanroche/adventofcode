import Foundation

let lines = stringsFromFile()

public func part1() -> Int {
    var total = 0
    for line in lines {
        guard line != "" else { break }
        let first = line.split(separator: ",")[0].split(separator: "-").compactMap { Int($0) }
        let second = line.split(separator: ",")[1].split(separator: "-").compactMap { Int($0) }
        let set0 = Set(stride(from: first[0], through: first[1], by: 1))
        let set1 = Set(stride(from: second[0], through: second[1], by: 1))
        if set0.isSubset(of: set1) || set1.isSubset(of: set0) {
            total += 1
        }
    }
    return total
}

