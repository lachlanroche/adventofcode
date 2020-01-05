import Foundation

public func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input08", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

public extension String {
    func santaInput() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func santaContentLength() -> Int {
        var length = 0
        var ignore = -1
        var escape = false
        
        for (i,ch) in dropLast().dropFirst().enumerated() {
            if escape {
                escape = false
                if ch == "x" {
                    ignore = i + 2
                }
                continue
            }
            
            if ignore >= i {
                continue
            }
            
            if ch == "\\" {
                escape = true
            }
            
            length = 1 + length
        }
        
        return length
    }
    
    func santaEncode() -> String {
        var chars =  [Character]()
        chars.append("\"")
        
        for ch in self {
            if ch == "\"" || ch == "\\" {
                chars.append("\\")
            }
            chars.append(ch)
        }
        
        chars.append("\"")
        return String(chars)
    }
    
    func santaEncodeLength() -> Int {
        var length = 2
        
        for ch in self {
            if ch == "\"" || ch == "\\" {
                length = 2 + length
            } else {
                length = 1 + length
            }
        }
        
        return length
    }
}

public func part1() -> Int {
    return inputstring()
        .components(separatedBy: "\n")
        .reduce(0) {
            (acc, line) in
            let input = line.santaInput()
            return acc + input.count - input.santaContentLength()
        }
}

// TODO still got some error in here
public func part2() -> Int {
    return inputstring()
        .components(separatedBy: "\n")
        .reduce(0) {
            (acc, line) in
            let input = line.santaInput()
            return acc + input.santaEncodeLength() - input.count
        }
}
