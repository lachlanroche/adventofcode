import Foundation

func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input14", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

func inputData() -> [Reindeer] {
    var herd = [Reindeer]()

    for s in inputstring().components(separatedBy: "\n") {
        let str = s.components(separatedBy: " ")
        guard str.count == 15 else { continue }
        let name = str[0]
        let speed = Int(str[3])!
        let endurance = Int(str[6])!
        let rest = Int(str[13])!
 
        herd.append(Reindeer(name: name, speed: speed, endurance: endurance, rest: rest))
    }
    
    return herd
}

struct Reindeer: Hashable {
    let name: String
    let speed: Int
    let endurance: Int
    let rest: Int
}

extension Reindeer {
    func sprint(for t: Int) -> Int {
        let cycles = t / (endurance + rest)
        let mod = t % (endurance + rest)
        return (speed * endurance * cycles) + speed * min (mod, endurance)
    }
}

public func part1() -> Int
{
    let herd = inputData()
    
    var best = 0
    for beast in herd {
        let dist = beast.sprint(for: 2503)
        if dist > best {
            best = dist
        }
    }
    
    return best
}
