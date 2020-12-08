import Foundation

func inputData() -> World {
    var world = World()
    for str in stringsFromFile(named: "input") {
        guard str != "" else { continue }
        let ss = str.components(separatedBy: " ")
        if ss.count == 1 {
            world.molecule = ss[0]
        } else if ss.count == 3 {
            world.replacements.append((ss[0], ss[2]))
        }
    }
    return world
}

struct World {
    var molecule: String = ""
    var replacements: Array<(String, String)> = []
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
}

public func part1() -> Int {
    let world = inputData()
    var result: Set<String> = []
    
    for reaction in world.replacements {
        for r in world.molecule.ranges(of: reaction.0) {
            let str = world.molecule[..<r.lowerBound]
                .appending(reaction.1)
                .appending(world.molecule[r.upperBound...])
            result.insert(str)
        }
    }

    return result.count
}

public func part2() -> Int {
    let world = inputData()

    var num = 0
    var num_Rn = 0
    var num_Ar = 0
    var num_Y = 0
    
    let nsstr = world.molecule as NSString
    let regex = try! NSRegularExpression(pattern: "[A-Z][a-z]?")

    regex.enumerateMatches(in: world.molecule, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: nsstr.length)) {
      (result : NSTextCheckingResult?, _, _) in
        if let r = result {
            let result = nsstr.substring(with: r.range) as String
            num += 1
            if result == "Y" {
                num_Y += 1
            } else if result == "Ar" {
                num_Ar += 1
            } else if result == "Rn" {
                num_Rn += 1
            }
        }
    }

    return num - num_Rn - num_Ar - 2 * num_Y - 1
}
