import Foundation

public func part1() -> Int {
    var result = 0
    for str in stringsFromFile() {
        guard str.contains(" | ") else { continue }
        let s = str.components(separatedBy: " | ")
        
        for t in s[1].components(separatedBy: " ") {
            let l = t.count
            
            if l == 2 || l == 4 || l == 3 || l == 7 {
                result = 1 + result
            }
        }
    }
    
    return result
}
