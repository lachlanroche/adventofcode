import Foundation

func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input16", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

func inputData() -> [Sue] {
    var sues = [Sue]()

    for s in inputstring().components(separatedBy: "\n") {
        let str = s.replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: ",", with: "")
            .components(separatedBy: " ")
        if str.count < 2 {
            break
        }
        
        var sue = Sue(id: Int(str[1])!)

        var i = 3
        while i < str.count {
            let n = str[i-1]
            let v = Int(str[i])!
            sue.owns(v, of: n)
            i += 2
        }
 
        sues.append(sue)
    }
    
    return sues
}

struct Sue: Hashable {
    let id: Int
    var children: Int? = nil
    var cats: Int? = nil
    var samoyeds: Int? = nil
    var pomeranians: Int? = nil
    var akitas: Int? = nil
    var vizslas: Int? = nil
    var goldfish: Int? = nil
    var trees: Int? = nil
    var cars: Int? = nil
    var perfumes: Int? = nil
}

extension Sue {
    mutating func owns(_ n: Int, of name: String) {
        switch name {
        case "children": children = n; break
        case "cats": cats = n; break
        case "samoyeds": samoyeds = n; break
        case "pomeranians": pomeranians = n; break
        case "akitas": akitas = n; break
        case "vizslas": vizslas = n; break
        case "goldfish": goldfish = n; break
        case "trees": trees = n; break
        case "cars": cars = n; break
        case "perfumes": perfumes = n; break
        default: break
        }
    }
    
    func matches(with sue: Sue) -> Bool {
        if let children = children {
            guard children == sue.children else { return false }
        }
        if let cats = cats {
            guard cats == sue.cats else { return false }
        }
        if let samoyeds = samoyeds {
            guard samoyeds == sue.samoyeds else { return false }
        }
        if let pomeranians = pomeranians {
            guard pomeranians == sue.pomeranians else { return false }
        }
        if let akitas = akitas {
            guard akitas == sue.akitas else { return false }
        }
        if let vizslas = vizslas {
            guard vizslas == sue.vizslas else { return false }
        }
        if let goldfish = goldfish {
            guard goldfish == sue.goldfish else { return false }
        }
        if let trees = trees {
            guard trees == sue.trees else { return false }
        }
        if let cars = cars {
            guard cars == sue.cars else { return false }
        }
        if let perfumes = perfumes {
            guard perfumes == sue.perfumes else { return false }
        }
        return true
    }
}

public
func part1() -> Int {
    let present = Sue(id: -1, children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1)
    let sues = inputData()
    
    return sues.filter { $0.matches(with: present) }
        .map {$0.id}
        .first!
}
