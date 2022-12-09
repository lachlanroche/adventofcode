import Foundation

struct Nanobot: Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int
    let r: Int

    func manhattan(_ p: Nanobot) -> Int {
        return abs(x - p.x) + abs(y - p.y) + abs(z - p.z)
    }
}

public func part1() -> Int {
    var world = [Nanobot]()
    var strongest: Nanobot? = nil
    for line in stringsFromFile() {
        guard line != "" else { break }
        let xyzr = line.replacingOccurrences(of: "pos=<", with: "")
            .replacingOccurrences(of: ">, r=", with: ",")
            .split(separator: ",")
            .map { Int(String($0))! }
        let p = Nanobot(x: xyzr[0], y: xyzr[1], z: xyzr[2], r: xyzr[3])
        world.append(p)
        if strongest == nil {
            strongest = p
        } else if p.r > strongest!.r {
            strongest = p
        }
    }
    
    var result = 0
    for p in world {
        guard let strongest = strongest else { continue }
        guard strongest.manhattan(p) <= strongest.r else { continue }
        result += 1
    }
    
    return result
}

