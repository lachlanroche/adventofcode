import Foundation

func readMarker(_ input: inout [Character]) -> (Int, Int) {
    var buffer = [Character]()
    while !input.isEmpty {
        let ch = input.remove(at:0)
        if ch == ")" {
            let parts = String(buffer).split(separator: "x")
            return (Int(parts[0])!, Int(parts[1])!)
        } else {
            buffer.append(ch)
        }
    }
    return (0, 0)
}

public func part1() -> Int {
    var input = Array(stringsFromFile()[0])
    var output = [Character]()
    while !input.isEmpty {
        let ch = input.remove(at: 0)
        if ch == "(" {
            let (length, count) = readMarker(&input)
            let buffer = input[0..<length]
            for _ in 0..<count {
                output.append(contentsOf: buffer)
            }
            input.removeFirst(length)
        } else {
            output.append(ch)
        }
    }
    return output.count
}
