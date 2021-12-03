import Foundation


public func part1() -> Int {
    var z = 0
    var x = 0
    for s in stringsFromFile(named: "input") {
        let ss = stringsFromString(s, sep: " ")
        guard ss.count == 2 else { continue }
        let n = Int(ss[1])!
        switch ss[0] {
        case "up":
            z = z - n
            break
        case "down":
            z = z + n
            break
        case "forward":
            x = x + n
            break
        default:
            break
        }
    }
    return z*x
}

public func part2() -> Int {
    var z = 0
    var x = 0
    var aim = 0
    for s in stringsFromFile(named: "input") {
        let ss = stringsFromString(s, sep: " ")
        guard ss.count == 2 else { continue }
        let n = Int(ss[1])!
        switch ss[0] {
        case "up":
            aim = aim - n
            break
        case "down":
            aim = aim + n
            break
        case "forward":
            x = x + n
            z = z + (aim * n)
            break
        default:
            break
        }
    }
    return z*x
}
