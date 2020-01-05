import Foundation

let letters: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

extension Character {
    func letterIndex() -> Int {
        return Int(self.asciiValue!) - 97
    }
    func increment() -> Character {
        return letters[(1 + letterIndex()) % 26]
    }
}

extension Array where Element == Character {
    mutating func increment() {
        var index = count - 1
        
        while true {
            self[index] = self[index].increment()
            guard self[index] == "a" else { return }
            guard index > 0 else { break }
            index = index - 1
        }
        
        insert("a", at: 0)
    }
    
    func noStopLetters() -> Bool {
        for ch in self {
            switch ch {
            case "i", "o", "l":
                return false
            default:
                break
            }
        }
        return true
    }
    
    func hasIncreasingStraight() -> Bool {
        var pprev: UInt8 = 0
        var prev: UInt8 = 0
        
        for ch in self {
            let val = ch.asciiValue!
            if val == prev && prev == pprev {
                return true
            }
            
            pprev = 1 + prev
            prev = 1 + val
        }
        
        return false
    }
    
    func hasTwoPairs() -> Bool {
        var pairs = Set<Character>()
        
        var prev: Character = "_"
        for ch in self {
            if ch == prev {
                pairs.insert(ch)
                if pairs.count >= 2 {
                    return true
                }
            }
            prev = ch
        }
        
        return false
    }
    
    func isValid1() -> Bool {
        return noStopLetters() && hasIncreasingStraight() && hasTwoPairs()
    }
}

public func part1() -> String {
    var password = Array("hepxcrrq")
    
    repeat {
        password.increment()
    } while !password.isValid1()
    
    return String(password)
}

public func part2() -> String {
    var password = Array(part1())
    
    repeat {
        password.increment()
    } while !password.isValid1()
    
    return String(password)
}

