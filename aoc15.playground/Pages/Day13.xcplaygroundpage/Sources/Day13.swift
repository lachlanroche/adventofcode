import Foundation


func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input13", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

func inputData() -> [Rule] {
    var rules = [Rule]()

    for s in inputstring().components(separatedBy: "\n") {
        let str = s.components(separatedBy: " ")
        guard str.count == 11 else { continue }
        let sign: Int = str[2] == "gain" ? 1 : -1
        let happiness = Int(str[3])! * sign
        let person = str[0]
        let otherPerson = str[10].trimmingCharacters(in: .punctuationCharacters)
 
        rules.append(Rule(person: person, otherPerson: otherPerson, happiness: happiness))
    }
    
    return rules
}

// person +happiness when sit next to otherPerson
struct Rule {
    let person: String
    let otherPerson: String
    let happiness: Int
}

func happiness(for seating: [String], with rules: [Rule]) -> [String: Int]
{
    var result = Dictionary(uniqueKeysWithValues: seating.map{ ($0, 0) })
    
    func applyHappiness(for p1: String, and p2: String, with rules: [Rule])
    {
        if let rule1 = rules.first(where: { $0.person == p1 && $0.otherPerson == p2 }) {
            result[p1]! += rule1.happiness
        }
        if let rule2 = rules.first(where: { $0.person == p2 && $0.otherPerson == p1 }) {
            result[p2]! += rule2.happiness
        }
    }

    for (i, p1) in seating.enumerated() {
        if i==0 {
            applyHappiness(for: p1, and: seating.last!, with: rules)
        } else {
            applyHappiness(for: p1, and: seating[i-1], with: rules)
        }
    }
    return result
}

func totalHappiness(seating: [String:Int]) -> Int
{
    return seating.reduce(into: 0) { (result, kv) in
        result += kv.value
    }
}


public func part1() -> Int
{
    let rules = inputData()
    let people = Set(rules.map(\.person))
    
    let seatings = Combinatorics.permutationsWithoutRepetitionFrom(Array(people), taking: people.count)
    var best = totalHappiness(seating: happiness(for:seatings[0], with: rules))
    var bestSeating = seatings[0]

    for seating in seatings {
        let h = totalHappiness(seating: happiness(for:seating, with: rules))
        if h > best {
            best = h
            bestSeating = seating
        }
    }

    return best
}

