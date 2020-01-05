import Foundation

func lookAndSay(input: String) -> String {
    func say(result: inout [Character], char: Character, count: Int) {
        result.append(contentsOf: String(count))
        result.append(char)
    }
    
    var result = [Character]()
    var count = 1
    var prev: Character? = nil
    for ch in input {
        if prev == ch {
            count = 1 + count
        } else if let prev = prev {
            say(result: &result, char: prev, count: count)
            count = 1
        }
        prev = ch
    }
    if let prev = prev {
        say(result: &result, char: prev, count: count)
    }
    
    return String(result)
}

public func part1() -> Int {
    var s = "1113222113"
    for _ in 1...40 {
        s = lookAndSay(input: s)
    }
    return s.count
}

public func part2() -> Int {
    var s = "1113222113"
    for _ in 1...50 {
        s = lookAndSay(input: s)
    }
    return s.count
}
