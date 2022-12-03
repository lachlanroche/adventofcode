import Foundation

let lines = stringsFromFile()

public func part1() -> Int {
    var total = 0
    for line in lines {
        guard line != "" else { break }
        let carray = Array(line)
        let first = Set(carray.prefix(carray.count / 2))
        let second = Set(carray.suffix(carray.count / 2))
        let both = first.intersection(second)
        guard let common = both.first else { continue }
        if common.isUppercase {
            total += 27 + Int(common.asciiValue!) - 65
        } else {
            total += 1 + Int(common.asciiValue!) - 97
        }
    }
    return total
}
