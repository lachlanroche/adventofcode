import Foundation

enum Token: Hashable, Equatable {
    case number(Int)
    case left
    case right
}

func tokens(_ s: String) -> [Token] {
    var result = [Token]()
    for c in s {
        if c == "[" {
            result.append(.left)
        } else if c == "]" {
            result.append(.right)
        } else if "0"..."9" ~= c {
            let a = Int(c.asciiValue!) - 48
            result.append(.number(a))
        }
    }
    return result
}

func inputData() -> [[Token]] {
    var result = [[Token]]()
    for str in stringsFromFile() {
        guard str.hasPrefix("[") else { continue }
        result.append(tokens(str))
    }
    return result
}

func explode(token: inout [Token]) -> Bool {
    var depth = 0
    var beforeIndex: Int? = nil
    for i in 0..<Int.max {
        guard i < token.count else { break }
        switch token[i] {
        case .left:
            depth = depth + 1
            break
        case .right:
            depth = depth - 1
            break
        case .number(let a):
            if case .number(let b) = token[i+1], depth > 4 {
                if let beforeIndex = beforeIndex {
                    if case .number(let before) = token[beforeIndex] {
                        token[beforeIndex] = .number(before + a)
                    }
                }
                
                for j in (i+2)..<token.count {
                    if case .number(let d) = token[j] {
                        token[j] = .number(d + b)
                        break
                    }
                }

                token[i] = .number(0)
                token.remove(at: i+1)
                token.remove(at: i+1)
                token.remove(at: i - 1)
                return true

            } else {
                beforeIndex = i
            }
        }
    }
    
    return false
}

func split(token: inout [Token]) -> Bool {
    for i in 0..<token.count {
        if case .number(let value) = token[i], value >= 10 {
            token.remove(at: i)
            token.insert(.left, at: i)
            token.insert(.number(value/2), at: i+1)
            token.insert(.number(value/2 + value % 2), at: i+2)
            token.insert(.right, at: i+3)

            return true
        }
    }
    return false
}

func add(_ a: [Token], _ b: [Token]) -> [Token] {
    var result = [Token]()
    result.append(.left)
    result.append(contentsOf: a)
    result.append(contentsOf: b)
    result.append(.right)
    
    while true {
        if explode(token: &result) { continue }
        if split(token: &result) { continue }
        return result
    }
}

func draw(_ token: [Token]) -> String {
    var result = ""
    for i in 0..<token.count {
        switch token[i] {
        case .left:
            result.append("[")
            break
        case .right:
            result.append("]")
            break
        case .number(let a):
            result.append(String(a))
            result.append(" ")
            break
        }
    }

    return result
}

func magnitude(_ token: [Token]) -> Int {
    var result = [Int]()
    for t in token {
        switch t {
        case .left:
            break
        case .right:
            let a = 2 * result.removeLast()
            let b = 3 * result.removeLast()
            result.append(a + b)
            break
        case .number(let v):
            result.append(v)
            break
        }
    }
    return result.last!
}

public func part1() -> Int {
    let tokens = inputData()
    
    var result = [Token]()
    for t in tokens {
        if result.isEmpty {
            result = t
        } else {
            result = add(result, t)
        }
    }
    
    return magnitude(result)
}

