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

