import Foundation

public func part1() -> Int {
    let data = stringFromFile()
    var recent = [Character]()
    var position = 0
    for ch in data {
        if Set(recent).count == 4 {
            print(ch)
            print(recent)
            return position
        }
        if recent.count == 4 {
            recent.remove(at: 0)
        }
        recent.append(ch)
        position += 1
    }
    
    return -1
}

