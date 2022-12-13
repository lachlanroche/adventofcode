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

public func part2() -> Int {
    let input = Array(stringsFromFile()[0])
    var result = 0
    var weights = Array(repeating: 1, count: input.count)
    var marker: [Character]? = nil
    for (i, ch) in input.enumerated() {
        if let buffer = marker {
            if ch == ")" {
                let parts = String(buffer).split(separator: "x")
                marker = nil
                let length = Int(parts[0])!
                let count = Int(parts[1])!
                for j in (i+1)...(i+length) where j < weights.count {
                    weights[j] *= count
                }
            } else {
                marker?.append(ch)
            }
        } else if ch == "(" {
            marker = []
        } else {
            result += weights[i]
        }
    }
    return result
}
