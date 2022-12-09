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

struct Computer {
    var reg = Dictionary<String, Int>()
    let prog: [[String]]
    var input = [Int]()
    var pc = 0
    var sent = 0
    var count = 0
    var blocked = false
    var terminated = false
    
    init(prog: [[String]], id: Int) {
        self.prog = prog
        reg["p"] = id
    }
    
    func value(_ key: String) -> Int {
        if let value = Int(key) {
            return value
        } else {
            return reg[key] ?? 0
        }
    }
}

public func part2() -> Int {
    let prog = stringsFromFile()
        .filter{ $0 != "" }
        .map{ $0.components(separatedBy: " ") }
    
    var c0 = Computer(prog: prog, id: 0)
    var c1 = Computer(prog: prog, id: 1)
    
    while true {
        c0.run(other: &c1)
        c1.run(other: &c0)
        
        if c0.isBlocked && c1.isBlocked {
            break
        }
    }

    return c1.sent
}

extension Computer {
    var isBlocked: Bool {
        get { blocked && input.isEmpty }
    }
    mutating func run(other: inout Computer) {
        blocked = false
        while true {
            guard 0..<(prog.count) ~= pc else {
                terminated = true
                return
            }
            guard !terminated else {
                blocked = true
                return
                
            }
            
            let p = prog[pc]
            let a = p[1]
            let b = p.count > 2 ? p[2] : ""
            var jumped = false
            switch p[0] {
            case "snd":
                other.input.append(value(a))
                sent = 1 + sent
                break
            case "set":
                reg[a] = value(b)
                break
            case "add":
                reg[a] = (reg[a] ?? 0) + value(b)
                break
            case "mul":
                reg[a] = (reg[a] ?? 0) * value(b)
                break
            case "mod":
                reg[a] = (reg[a] ?? 0) % value(b)
                break
            case "rcv":
                if input.isEmpty {
                    blocked = true
                    return
                }
                reg[a] = input.remove(at: 0)
                break
            case "jgz":
                if value(a) > 0 {
                    pc += value(b)
                    jumped = true
                }
                break
            default:
                return
            }
            count += 1
            if !jumped {
                pc += 1
            }
        }
    }
}
