import Foundation

public func part1() -> Int {
    let prog = stringsFromFile(named: "input")
    var reg = Dictionary<String, Int>()
    var mulCount = 0
    var pc = 0
    
    while true {
        guard pc >= 0 else { break }
        guard pc < prog.count else { break }
        let ps = prog[pc]
        guard ps != "" else { break }
        let instr = ps.components(separatedBy: " ")
        let a = instr[1]
        let b = instr[2]
        let ai = Int(a)
        let bi = Int(b)
        switch instr[0] {
        case "set":
            if let bi = bi {
                reg[a] = bi
            } else {
                reg[a] = (reg[b] ?? 0)
            }
            pc += 1
            break
        case "sub":
            if let bi = bi {
                reg[a] = (reg[a] ?? 0) - bi
            } else {
                reg[a] = (reg[a] ?? 0) - (reg[b] ?? 0)
            }
            pc += 1
            break
        case "mul":
            if let bi = bi {
                reg[a] = (reg[a] ?? 0) * bi
            } else {
                reg[a] = (reg[a] ?? 0) * (reg[b] ?? 0)
            }
            pc += 1
            mulCount += 1
            break
        case "jnz":
            let val = ai ?? reg[a] ?? 0
            if val != 0 {
                let offset = bi ?? reg[b] ?? 0
                pc += offset
            } else {
                pc += 1
            }
            break
        default:
            break
        }
    }
    
    return mulCount
}

public func part2() -> Int {
    var a = 1
    var b = 67
    var c = 67
    var d = 0
    var f = 0
    var g = 0
    var h = 0
    
    b = b * 100 + 100000
    c = b + 17000
    while true {
        f = 1
        d = 2
        var i = d
        while i * i < b {
            if b % i == 0 {
                f = 0
                break
            }
            i = 1 + i
        }
        if f == 0 { h = 1 + h }
        g = b - c
        b = b + 17
        if g == 0 { break }
    }

    return h
}
