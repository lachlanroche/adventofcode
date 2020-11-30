import Foundation


func boxIdFrequencies(_ str: String) -> (two: Bool, three: Bool) {
    var freq: [Character:Int] = [:]
    for var s in str {
        if let f = freq[s] {
            freq[s] = 1 + f
        } else {
            freq[s] = 1
        }
    }
    
    return (two: freq.values.contains(2), three: freq.values.contains(3))
}

func boxIdChecksum(_ boxIds: [String]) -> Int {
    let freqs = boxIds.map(boxIdFrequencies)
    let two = freqs.filter { $0.two }.count
    let three = freqs.filter { $0.three }.count
    return two * three
}


public
func part1() -> Int {
    //let boxIds = stringsFromString("abcdef, bababc, abbcde, abcccd, aabcdd, abcdee, ababab")
    let boxIds = stringsFromFile(named: "input")
    return boxIdChecksum(boxIds)
}

func hammingDistance(_ s1: String, _ s2: String) -> Int {
    return zip(s1, s2).reduce(0) { (acc,zz) in
        return zz.0 == zz.1 ? acc : acc + 1
    }
}

//hammingDistance("fghij", "fghij")
//hammingDistance("fghij", "fguij")

func correctBoxIds(boxIds: [String]) -> [String] {
    
    for (i,a) in boxIds.enumerated() {
        for (_,b) in boxIds.dropFirst(i+1).enumerated() {
            if 1 == hammingDistance(a, b) {
                return [a, b]
            }
        }
    }
    
    return []
}

public
func part2() -> String {
    

    let p2 = stringsFromString("abcde, fghij, klmno, pqrst, fguij, axcye, wvxyz")
    let boxIds = stringsFromFile(named: "input")

    let correct = correctBoxIds(boxIds: boxIds)

    let common = String(zip(correct[0], correct[1]).flatMap { $0 == $1 ? $0 : nil })
    
    return common
}
