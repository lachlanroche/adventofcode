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
