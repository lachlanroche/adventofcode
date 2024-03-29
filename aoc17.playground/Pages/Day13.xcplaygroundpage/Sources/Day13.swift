import Foundation

func depths() -> [Int:Int] {
    return [
        0: 4,
        1: 2,
        2: 3,
        4: 5,
        6: 6,
        8: 4,
        10: 8,
        12: 6,
        14: 6,
        16: 8,
        18: 8,
        20: 6,
        22: 8,
        24: 9,
        26: 8,
        28: 8,
        30: 12,
        32: 12,
        34: 10,
        36: 12,
        38: 12,
        40: 10,
        42: 12,
        44: 12,
        46: 12,
        48: 12,
        50: 12,
        52: 14,
        54: 14,
        56: 12,
        58: 14,
        60: 14,
        62: 14,
        64: 17,
        66: 14,
        70: 14,
        72: 14,
        74: 14,
        76: 14,
        78: 18,
        82: 14,
        88: 18,
        90: 14,
    ]
}

public func part1() -> Int {
    let depths = depths()
    var score = 0
    for t in 0...90 {
        guard let depth = depths[t] else { continue }
        let caught = 0 == t % ((depth - 1 ) * 2)
        if caught {
            score = score + depth * t
        }
    }
    return score
}

public func part2() -> Int {
    let depths = depths()
    for d in 0...Int.max {
        var ok = true
        for t in 0...90 {
            guard let depth = depths[t] else { continue }
            let caught = 0 == (t + d) % ((depth - 1 ) * 2)
            if caught {
                ok = false
                break
            }
        }
        if ok {
            return d
        }
    }
    return 0
}
