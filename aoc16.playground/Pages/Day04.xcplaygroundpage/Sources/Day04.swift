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

extension Character {
    func rot13(_ n: Int) -> Character {
        guard
            let asciiValue = asciiValue,
            97...122 ~= asciiValue
        else { return self }
        
        return Character(UnicodeScalar(97+(Int(asciiValue) - 97 + n) % 26)!)
    }
}

public func part2() -> Int {
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
        guard String(values.map({ $0.2 })).hasPrefix(checksum) else { continue }
        
        let name = prefix.filter({ $0.isLetter || $0 == "-"})
            .map({ $0 == "-" ? " " : $0 })
            .map({ $0.rot13(id) })
        
        if String(name).contains("north") {
            return id
        }
    }
    return 0
}
