import Foundation

public func part1() -> Int {
    var reg = Dictionary<String, Int>()
    var sound = 0
    let prog = stringsFromFile()
        .filter{ $0 != "" }
        .map{ $0.components(separatedBy: " ") }
    var pc = 0
    while true {
        var p = prog[pc]
        let a = p[1]
        let b = p.count > 2 ? p[2] : ""
        switch p[0] {
        case "snd":
            if let ai = Int(a) {
                sound = ai
            } else {
                sound = reg[a] ?? 0
            }
            break
        case "set":
            if let bi = Int(b) {
                reg[a] = bi
            } else {
                reg[a] = reg[b]!
            }
            break
        case "add":
            if let bi = Int(b) {
                reg[a] = (reg[a] ?? 0) + bi
            } else {
                reg[a] = (reg[a] ?? 0) + (reg[b] ?? 0)
            }
            break
        case "mul":
            if let bi = Int(b) {
                reg[a] = (reg[a] ?? 0) * bi
            } else {
                reg[a] = (reg[a] ?? 0) * (reg[b] ?? 0)
            }
            break
        case "mod":
            if let bi = Int(b) {
                reg[a] = (reg[a] ?? 0) % bi
            } else {
                reg[a] = (reg[a] ?? 0) % (reg[b] ?? 0)
            }
            break
        case "rcv":
            if sound != 0 {
                return sound
            }
            break
        case "jgz":
            if reg[a] ?? 0 > 0 {
                if let bi = Int(b) {
                    pc += bi
                } else {
                    pc += reg[b] ?? 0
                }
                continue
            }
            break
        default:
            return -1
            break
        }
        pc += 1
    }
}
