import Foundation

public func part1() -> String {
    var counts: Array<Dictionary<Character,Int>> = [
        [:], [:], [:], [:], [:], [:], [:], [:]
    ]
    // nokeeods
    for line in stringsFromFile() where line != "" {
        for (i, ch) in line.enumerated() {
            counts[i][ch] = 1 + (counts[i][ch] ?? 0)
        }
    }
    
    let result: [Character] = counts.map {
        var count = -1
        var result: Character = "_"
        for (ch, c) in $0 {
            if c > count {
                count = c
                result = ch
            }
        }
        return result
    }
    
    return String(result)
}

