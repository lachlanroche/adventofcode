
import Foundation


public func part1() -> Int {
    for i in 800_000... {
        var count = 0
        for e in 1...i where 0 == i % e {
            count += 10 * e
        }
        if count >= 36_000_000 {
            return i
        }
    }
    return 0
}

public func part2() -> Int {
    for i in 850_000... {
        var count = 0
        for e in (i/50 - 1)...i where 0 == i % e {
            if i <= e * 50 {
                count += 11 * e
            } else {
                break
            }
        }
        if count >= 36_000_000 {
            return i
        }
    }
    return 0
}
