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
