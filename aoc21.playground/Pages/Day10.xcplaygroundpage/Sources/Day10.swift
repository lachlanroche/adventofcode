import Foundation

func inputData() -> [String] {
    return stringsFromFile().filter { $0 != "" }
}

public func part1() -> Int {
    let match: Dictionary<Character, Character> = ["(": ")", "{": "}", "[": "]", "<": ">"]

    func check(_ line: String) -> Int {
        var stack = Array<Character>()
        for c in line {
            if let _ = match[c] {
                stack.append(c)
            } else {
                let d = stack.removeLast()
                if c == match[d] {
                    continue
                }
                if c == ")" { return 3 }
                if c == "]" { return 57 }
                if c == "}" { return 1197 }
                if c == ">" { return 25137 }
            }
        }
        return 0
    }

    var result = 0
    for line in inputData() {
        result = result + check(line)
    }
    return result
}

public func part2() -> Int {
    let match: Dictionary<Character, Character> = ["(": ")", "{": "}", "[": "]", "<": ">"]

    func complete(_ line: String) -> String? {
        var stack = Array<Character>()
        for c in line {
            if let _ = match[c] {
                stack.append(c)
            } else {
                let d = stack.removeLast()
                if c == match[d] {
                    continue
                }
                return nil
            }
        }
        return String(stack.reversed().map({match[$0]!}))
    }

    var scores = [Int]()
    for line in inputData() {
        guard let s = complete(line) else { continue }
        var score = 0
        for c in s {
            score = 5 * score
            if c == ")" { score = 1 + score }
            if c == "]" { score = 2 + score }
            if c == "}" { score = 3 + score }
            if c == ">" { score = 4 + score }
        }
        scores.append(score)
    }
    
    scores.sort()
    return scores[(scores.count / 2)]
}
