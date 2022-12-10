import Foundation

public func part1() -> Int {
    var result: [Int] = [0]
    var x = 1
    for line in stringsFromFile() {
        guard line != "" else { break }
        if line == "noop" {
            result.append(x)
        } else if line.hasPrefix("addx") {
            let v = Int(line.split(separator: " ").last!)!
            result.append(x)
            result.append(x)
            x += v
        }
    }
    
    return result[20] * 20 +
        result[60] * 60 +
        result[100] * 100 +
        result[140] * 140 +
        result[180] * 180 +
        result[220] * 220
}
