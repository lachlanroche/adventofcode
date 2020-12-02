import Foundation

public
func part1() -> Int {
    var candidates: Set<Int> = []
    
    for n in stringsFromFile(named: "input").compactMap { Int($0) } {
        if candidates.contains(n) {
            let m = 2020 - n
            return n * m
        }
        candidates.insert(2020 - n)
    }
    
    return 0
}

public
func part2() -> Int {
    var numbers = stringsFromFile(named: "input").compactMap { Int($0) }

    for i in numbers {
        for j in numbers {
            for k in numbers {
                if 2020 == i + j + k {
                    return i * j * k
                }
            }
        }
    }
    
    return 0
}
