import Foundation

public func part1() -> Int {
    var result = 0
    for line in stringsFromFile() where line != "" {
        let prefix = line.split(separator: "[")[0]
        let id = Int(prefix.split(separator: "-").last!)!
        let checksum = line.split(separator: "[")[1].replacingOccurrences(of: "]", with: "")
        var counts = Dictionary<Character, Int>()
        for p in prefix.filter({ $0.isLetter }) {
            counts[p] = 1 + (counts[p] ?? 0)
            
        }
        var values = [(Int, Int, Character)]()
        for (k, v) in counts {
            values.append((v, Int(k.asciiValue!), k))
        }
        values.sort(by: { $0.0 == $1.0 ? ($0.1 < $1.1) : $0.0 > $1.0 })
        if String(values.map({ $0.2 })).hasPrefix(checksum) {
            result += id
        }
    }
    return result
}
