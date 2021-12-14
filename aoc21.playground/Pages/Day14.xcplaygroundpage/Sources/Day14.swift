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

func pairs(of s: String) -> [String:Int] {
    var result = [String: Int]()
    var b:Character? = nil
    for c in s {
        if let b = b {
            let t = String([b, c])
            result[t] = 1 + (result[t] ?? 0)
        }
        b = c
    }
    return result
}

public func part2() -> Int {
    let rules = rules()
    var pairs = pairs(of: "PBFNVFFPCPCPFPHKBONB")
    print(pairs)
    for _ in 0..<40 {
        var newPairs = [String:Int]()
        for pk in pairs.keys {
            let pn = pairs[pk]!
            let c = rules[pk]!.first!
            let l = pk.first!
            let r = pk.last!
            let a = String([l, c])
            let b = String([c, r])
            newPairs[a] = pn + (newPairs[a] ?? 0)
            newPairs[b] = pn + (newPairs[b] ?? 0)
        }
        pairs = newPairs
    }
    
    var counts = Dictionary<Character,Int>()
    counts["B"] = 1
    for pk in pairs.keys {
        let c = pk.first!
        counts[c] = pairs[pk]! + (counts[c] ?? 0)
    }
    return counts.values.max()! - counts.values.min()!
}
