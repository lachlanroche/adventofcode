import Foundation

func rules() -> Dictionary<String,String> {
    var result = Dictionary<String,String>()
    for s in stringsFromFile() {
        guard s.contains(" -> ") else { continue }
        let parts = s.components(separatedBy: " -> ")
        result[parts[0]] = parts[1]
    }
    return result
}

func step(_ s: String, rules: Dictionary<String,String>) -> String {
    var result = Array<Character>()
    
    var b:Character? = nil
    for c in s {
        if let b = b {
            if let r = rules[String([b, c])] {
                for rc in r {
                    result.append(rc)
                }
            }
        }
        b = c
        result.append(c)
    }

    return String(result)
}

public func part1() -> Int {
    let rules = rules()
    var polymer = "PBFNVFFPCPCPFPHKBONB"
    for _ in 0..<10 {
        polymer = step(polymer, rules: rules)
    }
    var counts = Dictionary<Character,Int>()
    for c in polymer {
        counts[c] = 1 + (counts[c] ?? 0)
    }
    return counts.values.max()! - counts.values.min()!
}

