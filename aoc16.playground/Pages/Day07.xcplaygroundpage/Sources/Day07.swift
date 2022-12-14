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
