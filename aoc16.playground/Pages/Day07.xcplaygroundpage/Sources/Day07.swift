import Foundation

public func part1() -> Int {
    var result = 0
    for line in stringsFromFile() where line != "" {
        var square = false
        var abbaRegular = false
        var abbaSquare = false
        var buffer = [Character]()
        
        for ch in line {
            if square && ch == "]" {
                buffer = []
                square = false
            } else if !square && ch == "[" {
                buffer = []
                square = true
            } else {
                buffer.append(ch)
                if buffer.count == 4 {
                    if buffer[0] != buffer[1] && buffer[0] == buffer[3] && buffer[1] == buffer[2] {
                        if square {
                            abbaSquare = true
                        } else {
                            abbaRegular = true
                        }
                    }
                    buffer.remove(at: 0)
                }
            }
        }
        if abbaRegular && !abbaSquare {
            result += 1
        }
    }
    return result
}

public func part2() -> Int {
    var result = 0
    for line in stringsFromFile() where line != "" {
        var square = false
        var aba = Set<String>()
        var bab = Set<String>()
        var buffer = [Character]()
        
        for ch in line {
            if square && ch == "]" {
                buffer = []
                square = false
            } else if !square && ch == "[" {
                buffer = []
                square = true
            } else {
                buffer.append(ch)
                if buffer.count == 3 {
                    if buffer[0] != buffer[1] && buffer[0] == buffer[2] {
                        if square {
                            aba.insert(String(buffer.dropFirst(1)))
                        } else {
                            bab.insert(String(buffer.dropLast(1)))
                        }
                    }
                    buffer.remove(at: 0)
                }
            }
        }
        if !aba.isEmpty && !aba.intersection(bab).isEmpty {
            result += 1
        }
    }
    return result
}
