import Foundation

func inputData() -> [Claim] {
    return stringsFromFile(named: "input")
        .compactMap( Claim.init )
}

struct Claim {
    let id: String
    let x: Int
    let y: Int
    let width: Int
    let height: Int
    
    init?( str: String ) {
        guard str != "" else { return nil }
        let s = str.components(separatedBy: CharacterSet.whitespaces)
        guard s.count == 4 else { return nil }
        id = s[0]
        
        let origin = s[2].trimmingCharacters(in: .punctuationCharacters).components(separatedBy: ",")
        x = Int(origin[0])!
        y = Int(origin[1])!
        let size = s[3].components(separatedBy: "x")

        width = Int(size[0])!
        height = Int(size[1])!
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
}

extension Claim {
    var position: Position {
        get {
            return Position(x: x, y:y)
        }
    }
    var claims: [Position] {
        get {
            var claim: [Position] = []
            for i in 0..<width {
                for j in 0..<height {
                    claim.append(Position(x: x + i, y: y + j))
                }
            }
            return claim;
        }
    }
}

public func part1() -> Int {
    var claimed: Dictionary<Position, Set<String>> = [:]
    
    inputData().forEach { elf in
        elf.claims.forEach { c in
            if claimed[c] == nil {
                claimed[c] = [elf.id]
            } else {
                var cc = claimed[c]
                cc?.insert(elf.id)
                claimed[c] = cc
            }
        }
    }
    
    return claimed.filter{ kv in
        kv.value.count > 1
    }.count
}

