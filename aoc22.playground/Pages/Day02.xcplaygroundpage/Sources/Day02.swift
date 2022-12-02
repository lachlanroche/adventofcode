import Foundation

let data = stringsFromFile()

func score(_ a: Int, _ x: Int) -> Int {
    var win: Int = 0
    if x == a {
        win = 3
    } else if (x == 1 + a) || (x == 1 && a == 3) {
        win = 6
    }
    return x + win
}

public func part1() -> Int {
    var total: Int = 0
    for line in data {
        guard line != "" else { break }
        let abc = Int(Array(line)[0].asciiValue!) - 64
        let xyz = Int(Array(line)[2].asciiValue!) - 87
        total += score(abc, xyz)
    }
    return total
}
