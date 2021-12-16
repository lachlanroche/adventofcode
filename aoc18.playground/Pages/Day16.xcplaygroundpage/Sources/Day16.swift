import Foundation

func inputData() -> [[Int]] {
    var result = [[Int]]()
    var arr = [Int]()
    for s in stringsFromFile() {
        if s.hasPrefix("Before") {
            arr = arr + s[9..<19].components(separatedBy: ", ").map({ Int($0)! })
        } else if s.hasPrefix("After") {
            arr = arr + s[9..<19].components(separatedBy: ", ").map({ Int($0)! })
            result.append(arr)
            arr = []
        } else if s != "" {
            arr = arr + s.components(separatedBy: " ").map({ Int($0)! })
        }
    }
    return result
}

func program() -> [[Int]] {
    var result = [[Int]]()
    for s in stringsFromFile(named: "program") {
        guard s != "" else { continue }
        result.append(s.components(separatedBy: " ").map({ Int($0)! }))
    }
    return result
}


func addr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] + data[b]
    return data
}
func addi(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] + b
    return data
}
func mulr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] * data[b]
    return data
}
func muli(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] * b
    return data
}
func banr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] & data[b]
    return data
}
func bani(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] & b
    return data
}
func borr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] | data[b]
    return data
}
func bori(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] | b
    return data
}
func setr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a]
    return data
}
func seti(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = a
    return data
}
func gtir(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = a > data[b] ? 1 : 0
    return data
}
func gtri(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] > b ? 1 : 0
    return data
}
func gtrr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] > data[b] ? 1 : 0
    return data
}
func eqir(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = a == data[b] ? 1 : 0
    return data
}
func eqri(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] == b ? 1 : 0
    return data
}
func eqrr(_ input: [Int],_ a: Int, _ b : Int, _ c: Int) -> [Int] {
    var data = input
    data[c] = data[a] == data[b] ? 1 : 0
    return data
}

typealias OPCODE = ([Int], Int, Int, Int) -> [Int]

func matchesThreeOpcodes(before: [Int], instr: [Int], after: [Int]) -> Bool {
    var match = 0
    let fn: [OPCODE] = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]
    
    for f in fn {
        let a = instr[1]
        let b = instr[2]
        let c = instr[3]
        if after == f(before, a, b, c) {
            match = 1 + match
        }
    }

    return match >= 3
}

public func part1() -> Int {
    var result = 0
    for line in inputData() {
        let before = Array(line[0..<4])
        let instr = Array(line[4..<8])
        let after = Array(line[8..<12])
        if matchesThreeOpcodes(before: before, instr: instr, after: after) {
            result = 1 + result
        }
    }
    
    return result
}

struct Opcode: Hashable, Equatable {
    let name: String
    let op: OPCODE
    
    func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

func matchOpcodes(before: [Int], instr: [Int], after: [Int], unknown: Set<Opcode>) -> Set<Opcode> {
    var match = Set<Opcode>()
    let a = instr[1]
    let b = instr[2]
    let c = instr[3]
    
    for f in unknown {
        if after == f.op(before, a, b, c) {
            match.insert(f)
        }
    }
    
    return match
}

public func part2() -> Int {
    var unknown: Set<Opcode> = [
        Opcode(name: "addr", op: addr),
        Opcode(name: "addi", op: addi),
        Opcode(name: "mulr", op: mulr),
        Opcode(name: "muli", op: muli),
        Opcode(name: "banr", op: banr),
        Opcode(name: "bani", op: bani),
        Opcode(name: "borr", op: borr),
        Opcode(name: "bori", op: bori),
        Opcode(name: "setr", op: setr),
        Opcode(name: "seti", op: seti),
        Opcode(name: "gtir", op: gtir),
        Opcode(name: "gtri", op: gtri),
        Opcode(name: "gtrr", op: gtrr),
        Opcode(name: "eqir", op: eqir),
        Opcode(name: "eqri", op: eqri),
        Opcode(name: "eqrr", op: eqrr)
    ]
    
    var guess = [Int:Set<Opcode>]()
    var opcodes = [Int:Opcode]()

    for line in inputData() {
        let before = Array(line[0..<4])
        let instr = Array(line[4..<8])
        let after = Array(line[8..<12])
        let matches = matchOpcodes(before: before, instr: instr, after: after, unknown: unknown)
        let n = instr[0]
        let op = matches.first!
        if matches.count == 1 {
            opcodes[n] = op
            for i in 0..<16 {
                if guess[i, default: []].contains(op) {
                    guess[i]?.remove(op)
                }
            }
        } else {
            if let prevGuess = guess[n] {
                guess[n] = Set(matches).intersection(prevGuess)
            } else {
                guess[n] = Set(matches)
            }
        }
    }

    while !guess.isEmpty {
        let g = guess.filter({ $0.value.count == 1 }).first!
        let op = g.value.first!
        opcodes[g.key] = op

        guess.removeValue(forKey: g.key)
        for i in 0..<16 {
            if guess[i, default: []].contains(op) {
                guess[i]?.remove(op)
            }
        }
    }

    var data = [0, 0, 0, 0]
    for p in program() {
        guard let opcode = opcodes[p[0]] else { break }
        let f = opcode.op
        data = f(data, p[1], p[2], p[3])
    }
                   
    return data[0]
}
