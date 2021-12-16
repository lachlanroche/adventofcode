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

