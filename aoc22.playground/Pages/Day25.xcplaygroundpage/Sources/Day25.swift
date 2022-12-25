import Foundation


public func part1() -> String {
    var total = 0
    let value: [Character: Int] = [
        "=": -2,
        "-": -1,
        "0": 0,
        "1": 1,
        "2": 2,
    ]
    for line in stringsFromFile() where line != "" {
        var number = 0
        for ch in line {
            number *= 5
            number += value[ch]!
        }
        total += number
    }
    let digit: [Int: Character] = [
        0: "0",
        1: "1",
        2: "2",
        3: "=",
        4: "-"
    ]
    var result = [Character]()
    while total > 0 {
        let (q, r) = total.quotientAndRemainder(dividingBy: 5)
        result.insert(digit[r]!, at: 0)
        total = q
        if r == 3 || r == 4 {
            total += 1
        }
    }
    return String(result)
}
