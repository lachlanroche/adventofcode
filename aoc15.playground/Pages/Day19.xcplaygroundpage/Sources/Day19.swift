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
