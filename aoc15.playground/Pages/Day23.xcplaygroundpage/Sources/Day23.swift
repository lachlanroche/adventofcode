import Foundation

func evaluate(_ a0: Int, _ b0: Int) -> Int {
    var a = a0
    var b = b0
    var pc = 0
    let prog = stringsFromFile(named: "input")
        .filter{ $0 != "" }
        .map{ $0.components(separatedBy: " ")}
    
    while 0..<prog.count ~= pc {
        let op = prog[pc]
        
        if op[0] == "hlf" {
            if op[1] == "a" {
                a /= 2
            } else {
                b /= 2
            }
            pc += 1
            
        } else if op[0] == "tpl" {
            if op[1] == "a" {
                a *= 3
            } else {
                b *= 3
            }
            pc += 1
            
        } else if op[0] == "inc" {
            if op[1] == "a" {
                a += 1
            } else {
                b += 1
            }
            pc += 1
            
        } else if op[0] == "jmp" {
            pc += Int(op[1])!
            
        } else if op[0] == "jie" {
            if op[1] == "a" {
                if a % 2 == 0 {
                    pc += Int(op[2])!
                } else {
                    pc += 1
                }
            } else {
                if b % 2 == 0 {
                    pc += Int(op[2])!
                } else {
                    pc += 1
                }
            }
            
        } else if op[0] == "jio" {
            if op[1] == "a" {
                if a == 1 {
                    pc += Int(op[2])!
                } else {
                    pc += 1
                }
            } else {
                if b == 1 {
                    pc += Int(op[2])!
                } else {
                    pc += 1
                }
            }
        }
    }
        
    return b
}

public func part1() -> Int {
    return evaluate(0, 0)
}

public func part2() -> Int {
    return evaluate(1, 0)
}
