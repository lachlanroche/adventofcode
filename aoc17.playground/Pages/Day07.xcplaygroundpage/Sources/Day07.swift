import Foundation


func inputData() -> [String] {
    return stringsFromFile(named: "input")
        .filter{ $0 != "" }
}

public func part1() -> String {
    var below: Dictionary<String,String> = [:]
    var weight: Dictionary<String,Int> = [:]
    
    for str in inputData() {
        let s = str.components(separatedBy: .whitespaces)
            .map{ $0.trimmingCharacters(in: .punctuationCharacters) }
        let name = s[0]
        weight[name] = Int(s[1])!
        for above in s.dropFirst(3) {
            below[above] = name
        }
    }
    
    var k = weight.keys.first!
    while true {
        guard let b = below[k] else { return k }
        k = b
    }
}
