import Foundation

public func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input07", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

enum Instruction {
    case load(target: String, left: String)
    case and(target: String, left: String, right: String)
    case or(target: String, left: String, right: String)
    case not(target: String, left: String)
    case lshift(target: String, left: String, value: UInt16)
    case rshift(target: String, left: String, value: UInt16)
}

extension Instruction {
    var target: String {
        switch self {
        case .load(let target, _): return target
        case .and(let target, _, _): return target
        case .or(let target, _, _): return target
        case .not(let target, _): return target
        case .lshift(let target, _, _): return target
        case .rshift(let target, _, _): return target
        }
    }
    
    var inputs: [String] {
        switch self {
        case .load(_, let left): return [left]
        case .and(_, let left, let right): return [left, right]
        case .or(_, let left, let right): return [left, right]
        case .not(_, let left): return [left]
        case .lshift(_, let left, _): return [left]
        case .rshift(_, let left, _): return [left]
        }
    }
}

func parse(line: String) -> Instruction? {
    let str = line
        .replacingOccurrences(of: " -> ", with: " ")
        .components(separatedBy: " ")
    
    if str[0] == "" {
        return nil
    }
    
    if str.count == 2 {
        return .load(target: str[1], left: str[0])
        
    } else if str[0] == "NOT" {
        return .not(target: str[2], left: str[1])
        
    } else if str[1] == "AND" {
        return .and(target: str[3], left: str[0], right: str[2])
        
    } else if str[1] == "OR" {
        return .or(target: str[3], left: str[0], right: str[2])
        
    } else if str[1] == "LSHIFT" {
        return .lshift(target: str[3], left: str[0], value: UInt16(str[2])!)
        
    } else if str[1] == "RSHIFT" {
        return .rshift(target: str[3], left: str[0], value: UInt16(str[2])!)
    }
    
    return nil
}

struct Circuit {
    var wires: [String:Instruction] = [:]
    var cache: [String:UInt16] = [:]
}

extension Circuit {
    mutating func add(instruction: Instruction) {
        wires[instruction.target] = instruction
    }
    
    func evaluate(wire: String) -> UInt16 {
        var cache: [String:UInt16] = [:]
        return evaluate(wire: wire, cache: &cache)
    }
    
    func evaluate(wire: String, cache: inout [String:UInt16]) -> UInt16 {
        if let number = UInt16(wire) {
            cache[wire] = number
            return number
        }
        if let cached = cache[wire] {
            return cached
        }
        
        let instruction = wires[wire]!
        let inputs = instruction.inputs.map { self.evaluate( wire: $0, cache: &cache) }
        let result: UInt16
        
        switch instruction {
        case .load(_, _):
            result = inputs[0]
            break
        case .and(_, _, _):
            result = inputs[0] & inputs[1]
            break
        case .or(_, _, _):
            result = inputs[0] | inputs[1]
            break
        case .not(_, _):
            result = ~inputs[0]
            break
        case .lshift(_, _, let bits):
            result = inputs[0] << bits
            break
        case .rshift(_, _, let bits):
            result = inputs[0] >> bits
            break
        }
        
        cache[wire] = result
        return result
    }
}

public func part1() -> UInt16 {
    var circuit = Circuit()
    
    for s in inputstring().components(separatedBy: "\n") {
        guard let instr = parse(line: s) else { continue }
        circuit.add(instruction: instr)
    }
    
    return circuit.evaluate(wire: "a")
}

public func part2() -> UInt16 {
    var circuit = Circuit()
    
    for s in inputstring().components(separatedBy: "\n") {
        guard let instr = parse(line: s) else { continue }
        circuit.add(instruction: instr)
    }
    
    let part1 = circuit.evaluate(wire: "a")
    circuit.add(instruction: .load(target: "b", left: String(part1)))

    return circuit.evaluate(wire: "a")
}
