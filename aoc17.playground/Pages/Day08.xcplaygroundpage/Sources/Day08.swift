import Foundation

enum Max {
    case runtime
    case final
}

func evaluate(withMax: Max) -> Int {
    var register = Dictionary<String, Int>()
    var maxValue = 0
    
    func compare(_ op: String, _ a: Int, _ b: Int) -> Bool {
        if op == "==" {
            return a == b
        } else if op == "!=" {
            return a != b
        } else if op == ">" {
            return a > b
        } else if op == ">=" {
            return a >= b
        } else if op == "<=" {
            return a <= b
        } else if op == "<" {
            return a < b
        }
        return false
    }
    func accumulate(_ op: String, _ a: Int, _ b: Int) -> Int {
        if op == "inc" {
            return a + b
        } else {
            return a - b
        }
    }
    
    stringsFromFile(named: "input")
        .filter{ $0 != "" }
        .forEach { str in
            let s = str.components(separatedBy: " ")
            let test_reg = register[s[4]] ?? 0
            let test_val = Int(s[6])!
            if compare(s[5], test_reg, test_val) {
                let reg_val = register[s[0]] ?? 0
                let val = Int(s[2])!
                let result = accumulate(s[1], reg_val, val)
                register[s[0]] = result
                maxValue = max(maxValue, result)
            }
        }
    
    if withMax == .final {
        return register.map{ $0.value }.reduce(0, max)
    } else {
        return maxValue
    }
}

public func part1() -> Int {
    return evaluate(withMax: .final)
}

public func part2() -> Int {
    return evaluate(withMax: .runtime)
}
