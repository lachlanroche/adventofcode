import Foundation

func program(pc: inout Int) -> [Instruction] {
    var result = [Instruction]()
    for s in stringsFromFile() {
        guard s != "" else { continue }
        let parts = s.components(separatedBy: " ")
        if s.hasPrefix("#ip") {
            pc = Int(parts[1])!
        } else if s != "" {
            let a = Int(parts[1])!
            let b = Int(parts[2])!
            let c = Int(parts[3])!
            result.append(Instruction(opcode: parts[0], a: a, b: b, c: c))
        }
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

typealias Operation = ([Int], Int, Int, Int) -> [Int]
let Opcode: [String:Operation] = [
    "addr": addr,
    "addi": addi,
    "mulr": mulr,
    "muli": muli,
    "banr": banr,
    "bani": bani,
    "borr": borr,
    "bori": bori,
    "setr": setr,
    "seti": seti,
    "gtir": gtir,
    "gtri": gtri,
    "gtrr": gtrr,
    "eqir": eqir,
    "eqri": eqri,
    "eqrr": eqrr
]

struct Instruction {
    let opcode: String
    let a: Int
    let b: Int
    let c: Int
    
}

struct Computer {
    var mem = [0, 0, 0, 0, 0, 0]
    var ip = 0
    let pc: Int
    let program: [Instruction]
    
    mutating func step() -> Bool {
        guard 0..<(program.count) ~= ip else { return false }
        let op = program[ip]
        guard let f = Opcode[op.opcode] else { return false }
                
        mem[pc] = ip
        mem = f(mem, op.a, op.b, op.c)
        ip = mem[pc] + 1
        return true
    }
}

public func part1() -> Int {
    var pc = 0
    let program = program(pc: &pc)
    var computer = Computer(pc: pc, program: program)
    while computer.step() {
    }
    return computer.mem[0]
}

public func part2a() -> Int {
    var pc = 0
    let program = program(pc: &pc)
    var computer = Computer(pc: pc, program: program)
    computer.mem[0] = 1
    while computer.step() {}
    return computer.mem[0]
}
// ran that for a while to get 10551364

public func part2() -> Int {
    var answer = 0
    let target = 10551364
    for i in 1 ... target {
        if target % i == 0 { answer += i }
    }
    return answer
}
