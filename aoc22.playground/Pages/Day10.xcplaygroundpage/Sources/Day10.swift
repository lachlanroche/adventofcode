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

public func part2() -> Void {
    var result: [Int] = []
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
    
    var screen = ""
    for (i, signal) in result.enumerated() {
        if i%40 == 0 && i != 0 {
            screen.append("\n")
        }
        let x = i % 40
        if (x-1)...(x+1) ~= signal {
            screen.append("#")
        } else {
            screen.append(".")
        }
    }
    print(screen)
}
