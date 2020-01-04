import Foundation

public func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input05", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

extension String {
    func hasThreeVowels() -> Bool {
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        var count = 0

        for (_, ch) in self.enumerated() {
            if vowels.contains(ch) {
                count = count + 1
            }
            
            if count == 3 {
                return true
            }
        }
        
        return false
    }
    
    func hasRepeats() -> Bool {
        var prev =  Character("_")

        for (_, ch) in self.enumerated() {
            if prev == ch {
                return true
            }
            prev = ch
        }
        
        return false
    }
    
    func hasStopWords() -> Bool {
        let stop: Set<String> = ["ab", "cd", "pq", "xy"]
        var prev =  Character("_")

        for (_, ch) in self.enumerated() {
            let word = String([prev, ch])
            prev = ch
            if stop.contains(word) {
                return true
            }
        }
        
        return false
    }
}

public extension String {
    func isNice1() -> Bool {
        return hasThreeVowels() && hasRepeats() && !hasStopWords()
    }
}

public func part1() -> Int {
    return inputstring()
        .components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .reduce(0) { (acc, str) in
            if str.isNice1() {
                return acc + 1
            } else {
                return acc
            }
        }
}
