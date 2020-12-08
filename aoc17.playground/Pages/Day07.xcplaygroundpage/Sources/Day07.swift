import Foundation


func inputData() -> [String] {
    return stringsFromFile(named: "input")
        .filter{ $0 != "" }
}

public func part1() -> String {
    var below: Dictionary<String,String> = [:]
    var weight: Dictionary<String,Int> = [:]
    
    for str in inputData() {
        let s = str.components(separatedBy: .whitespaces)
            .map{ $0.trimmingCharacters(in: .punctuationCharacters) }
        let name = s[0]
        weight[name] = Int(s[1])!
        for above in s.dropFirst(3) {
            below[above] = name
        }
    }
    
    var k = weight.keys.first!
    while true {
        guard let b = below[k] else { return k }
        k = b
    }
}

public func part2() -> Int {
    var children: Dictionary<String,[String]> = [:]
    var mass: Dictionary<String,Int> = [:]

    for str in inputData() {
        let s = str.components(separatedBy: .whitespaces)
            .map{ $0.trimmingCharacters(in: .punctuationCharacters) }
        let name = s[0]
        mass[name] = Int(s[1])!
        if s.count > 2 {
            children[name] = Array(s.dropFirst(3))
        }
    }
    
    func weight(of node: String) -> Int {
        if nil == children[node] {
            return mass[node]!
        }

        var cweight = 0
        var cmass = Dictionary<String, Int>()
        var masses = Dictionary<Int, Int>()
        for child in children[node]! {
            let w = weight(of: child)
            cweight += w
            cmass[child] = w
            let cc = masses[w] ?? 0
            masses[w] = cc + 1
        }
        
        if masses.count == 2 {
            var uniq = 0
            var rest = 0
            for mm in masses {
                if mm.value == 1 {
                    uniq = mm.key
                } else {
                    rest = mm.key
                }
                print(mm)
            }
            let adjust: Int
            if uniq < rest {
                adjust = uniq - rest
            } else {
                adjust = rest - uniq
            }
            cweight += adjust
            
            for cm in cmass where cm.value == uniq {
                anomaly = adjust + mass[cm.key]!
            }
        }

        return mass[node]! + cweight
    }
    
    var anomaly = 0
    let _ = weight(of: part1())
    return anomaly
}
