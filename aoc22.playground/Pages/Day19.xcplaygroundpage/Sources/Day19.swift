import Foundation

struct Blueprint {
    let id: Int
    let oreOre: Int
    let clayOre: Int
    let obsidianOre: Int
    let obsidianClay: Int
    let geodeOre: Int
    let geodeObsidian: Int
}

func inputData() -> [Blueprint] {
    var result = [Blueprint]()
    for line in stringsFromFile() where line != "" {
        let parts = line.replacingOccurrences(of: ":", with: "").split(separator: " ")
        result.append(Blueprint(
            id: Int(parts[1])!,
            oreOre: Int(parts[6])!,
            clayOre: Int(parts[12])!,
            obsidianOre: Int(parts[18])!,
            obsidianClay: Int(parts[21])!,
            geodeOre: Int(parts[27])!,
            geodeObsidian: Int(parts[30])!
        ))
    }
    return result
}

extension Blueprint {
    func geodes(_ oreBot: Int, _ clayBot: Int, _ obsidianBot: Int, _ geodeBot: Int, _ ore: Int, _ clay: Int, _ obsidian: Int, _ geode: Int, _ timeLeft: Int) -> Int {
        
        let oreNext = ore + oreBot
        let clayNext = clay + clayBot
        let obsidianNext = obsidian + obsidianBot
        let geodeNext = geode + geodeBot
        
        if timeLeft <= 0 {
            return geodeNext
        }
        if ore >= self.geodeOre && obsidian >= self.geodeObsidian {
            return geodes(oreBot, clayBot, obsidianBot, geodeBot + 1, oreNext - self.geodeOre, clayNext, obsidianNext - self.geodeObsidian, geodeNext, timeLeft - 1)
        }
        if ore >= self.obsidianOre && clay >= self.obsidianClay {
            return geodes(oreBot, clayBot, obsidianBot + 1, geodeBot, oreNext - self.obsidianOre, clayNext - self.obsidianClay, obsidianNext, geodeNext, timeLeft - 1)
        }
        var results = [0]
        if ore < 5 {
            results.append(geodes(oreBot, clayBot, obsidianBot, geodeBot, oreNext, clayNext, obsidianNext, geodeNext, timeLeft - 1))
        }
        if ore >= self.oreOre {
            results.append(geodes(oreBot + 1, clayBot, obsidianBot, geodeBot, oreNext - self.oreOre, clayNext, obsidianNext, geodeNext, timeLeft - 1))
        }
        if ore >= self.clayOre {
            results.append(geodes(oreBot, clayBot + 1, obsidianBot, geodeBot, oreNext - self.clayOre, clayNext, obsidianNext, geodeNext, timeLeft - 1))
        }
        return results.reduce(0, max)
    }
}
public func part1() -> Int {
    inputData().map({ $0.id * $0.geodes(1, 0, 0, 0, 0, 0, 0, 0, 23) })
        .reduce(0, +)
}

