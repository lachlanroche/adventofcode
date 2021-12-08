import Foundation

public func part1() -> Int {
    var result = 0
    for str in stringsFromFile() {
        guard str.contains(" | ") else { continue }
        let s = str.components(separatedBy: " | ")
        
        for t in s[1].components(separatedBy: " ") {
            let l = t.count
            
            if l == 2 || l == 4 || l == 3 || l == 7 {
                result = 1 + result
            }
        }
    }
    
    return result
}

public func part1b() -> Int {
    var result = 0
    for str in stringsFromFile() {
        guard str.contains(" | ") else { continue }
        let s = str.components(separatedBy: " | ")
        
        result = result + s[1].components(separatedBy: " ").filter { [2, 3, 4, 7].contains($0.count) }.count
    }
    
    return result
}

func decode(_ input_s: [String], _ output_s: [String]) -> Int {

    let output = output_s.map { Set<Character>($0) }
    let input = input_s.map { Set<Character>($0) }
    
    var c1 = Set<Character>()
    var c7 = Set<Character>()
    var c4 = Set<Character>()
    var c8 = Set<Character>()
    for i in Set(input) {
        if i.count == 2 {
            c1 = i
        } else if i.count == 3 {
            c7 = i
        } else if i.count == 4 {
            c4 = i
        } else if i.count == 7 {
            c8 = i
        }
    }
    
    let s_a = c7.subtracting(c1)
    var s_b = Set<Character>()
    var s_c = Set<Character>()
    var s_f = Set<Character>()
    var s_e = Set<Character>()

    let allInput = input_s.joined(separator: "")
    for i in 97...103 {
        let ch = Character(UnicodeScalar(i)!)
        let cn = allInput.filter { $0 == ch }.count
        if cn == 4 {
            s_e.insert(ch)
        } else if cn == 6 {
            s_b.insert(ch)
        } else if cn == 8 && !s_a.contains(ch) {
            s_c.insert(ch)
        } else if cn == 9 {
            s_f.insert(ch)
        }
    }
    
    let s_d = c4.subtracting(s_b.union(s_c).union(s_f))
    let s_g = Set<Character>("abcdefg").subtracting(s_a.union(s_b).union(s_c).union(s_d).union(s_e).union(s_f))

    let c2 = c8.subtracting(s_b).subtracting(s_f)
    let c3 = c8.subtracting(s_b).subtracting(s_e)
    let c5 = c8.subtracting(s_c).subtracting(s_e)
    let c6 = c8.subtracting(s_c)
    let c9 = c8.subtracting(s_e)
    let c0 = c8.subtracting(s_d)
    
    var total = 0
    for s in output {
        if total != 0 {
            total = 10 * total
        }
        
        if s == c0 {
            total = 0 + total
        } else if s == c1 {
            total = 1 + total
        } else if s == c2 {
            total = 2 + total
        } else if s == c3 {
            total = 3 + total
        } else if s == c4 {
            total = 4 + total
        } else if s == c5 {
            total = 5 + total
        } else if s == c6 {
            total = 6 + total
        } else if s == c7 {
            total = 7 + total
        } else if s == c8 {
            total = 8 + total
        } else if s == c9 {
            total = 9 + total
        }
    }
    
    return total
}

public func part2() -> Int {
    
    var total = 0
    for str in stringsFromFile() {
        guard str.contains(" | ") else { continue }
        let s = str.components(separatedBy: " | ")
        
        var result = decode(s[0].components(separatedBy: " "), s[1].components(separatedBy: " "))
        total = total + result
    }
    
    return total
}
