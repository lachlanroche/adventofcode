import Foundation


public func part1() -> Int {
    let data = stringsFromFile()
    var n = 0
    var ones = [
        0: 0,
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
        7: 0,
        8: 0,
        9: 0,
        10: 0,
        11: 0,
    ]
    for d in data {
        guard d.count == 12 else { continue }
        n = 1 + n

        for i in 0...11 {
            if d[i] == "1" {
                ones[i] = 1 + ones[i]!
            }
        }
    }
    
    var gamma = 0
    var epsilon = 0
    for i in 0...11 {
        let one = ones[i]!
        let zero = n - one

        gamma = 2 * gamma
        epsilon = 2 * epsilon
        if one > zero {
            gamma = 1 + gamma
        } else {
            epsilon = 1 + epsilon
        }
    }
    
    return gamma * epsilon
}

func bitstringToInt(_ s: String, bits: Int = 12) -> Int {
    var result = 0
    for i in 0..<bits {
        result = 2 * result
        if s[i] == "1" {
            result = 1 + result
        }
    }
    return result
}

func oxygen(_ data: [String], bit: Int = 0) -> String {
    if data.count == 1 {
        return data[0]
    }
    
    let a = data.filter { $0[bit] == "1" }
    let b = data.filter { $0[bit] == "0" }

    if a.count >= b.count {
        return oxygen(a, bit: 1 + bit)
    } else {
        return oxygen(b, bit: 1 + bit)
    }
}

func scrubber(_ data: [String], bit: Int = 0) -> String {
    if data.count == 1 {
        return data[0]
    }
    
    let a = data.filter { $0[bit] == "1" }
    let b = data.filter { $0[bit] == "0" }

    if b.count <= a.count {
        return scrubber(b, bit: 1 + bit)
    } else {
        return scrubber(a, bit: 1 + bit)
    }
}

public func part2() -> Int {
    let data = stringsFromFile().filter { $0.count == 12 }
    
    return bitstringToInt(oxygen(data)) * bitstringToInt(scrubber(data))
}
