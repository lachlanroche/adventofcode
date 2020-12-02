import Foundation

func inputData() -> [[String]] {
    return stringsFromFile(named: "input")
        .map{ $0.components(separatedBy: .whitespaces) }
        .filter{ $0.count > 1 }
}

public func part1() -> Int {
    func isValid(_ words: [String]) -> Bool {
        var seen: Set<String> = []
        for w in words {
            guard !seen.contains(w) else { return false }
            seen.insert(w)
        }
        return true
    }
    return inputData().filter{ isValid($0) }.count
}
