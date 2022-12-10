import Foundation

public func part1() -> Int {
    var result = 0
    for line in stringsFromFile() {
        guard line != "" else { break }
        let sides = [
            Int(line[0..<5].trimmingCharacters(in: .whitespaces))!,
            Int(line[5..<10].trimmingCharacters(in: .whitespaces))!,
            Int(line[10..<15].trimmingCharacters(in: .whitespaces))!
        ].sorted()
        if sides[0] + sides[1] > sides[2] {
            result += 1
        }
    }
    return result
}

public func part2() -> Int {
    var result = 0
    var a = [Int]()
    var b = [Int]()
    var c = [Int]()
    for line in stringsFromFile() {
        guard line != "" else { break }
        let sides = [
            Int(line[0..<5].trimmingCharacters(in: .whitespaces))!,
            Int(line[5..<10].trimmingCharacters(in: .whitespaces))!,
            Int(line[10..<15].trimmingCharacters(in: .whitespaces))!
        ]
        a.append(sides[0])
        b.append(sides[1])
        c.append(sides[2])
        if a.count == 3 {
            let aa = a.sorted()
            if aa[0] + aa[1] > aa[2] {
                result += 1
            }
            let bb = b.sorted()
            if bb[0] + bb[1] > bb[2] {
                result += 1
            }
            let cc = c.sorted()
            if cc[0] + cc[1] > cc[2] {
                result += 1
            }
            a = []
            b = []
            c = []
        }
        
        
    }
    return result
}
