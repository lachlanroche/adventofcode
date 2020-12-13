import Foundation

public func part1() -> String {
    var arr = Array("abcdefghijklmnop")
    for s in stringsFromFile(named: "input")[0].components(separatedBy: ",") {
        let t = s.dropFirst()
        let tt = t.components(separatedBy: "/")
        if s.hasPrefix("s") {
            let sn = arr.count - Int(s.dropFirst())!
            let arr0 = arr
            arr = []
            arr.append(contentsOf: arr0.dropFirst(sn))
            arr.append(contentsOf: arr0.prefix(upTo: sn))
        } else if s.hasPrefix("x") {
            let x0 = Int(tt[0])!
            let x1 = Int(tt[1])!
            arr.swapAt(x0, x1)

        } else if s.hasPrefix("p") {
            let p0 = arr.firstIndex(of: tt[0].first!)!
            let p1 = arr.firstIndex(of: tt[1].first!)!
            arr.swapAt(p0, p1)
        }
    }
    return String(arr)
}

public func part2() -> String {
    var arr = Array("ociedpjbmfnkhlga")
    let instr = stringsFromFile(named: "input")[0].components(separatedBy: ",")
    var seen = Set<String>()
    var history = Dictionary<Int, String>()
    for i in 0... {
        for s in instr {
            let t = s.dropFirst()
            let tt = t.components(separatedBy: "/")
            if s.hasPrefix("s") {
                let sn = arr.count - Int(s.dropFirst())!
                let arr0 = arr
                arr = []
                arr.append(contentsOf: arr0.dropFirst(sn))
                arr.append(contentsOf: arr0.prefix(upTo: sn))
            } else if s.hasPrefix("x") {
                let x0 = Int(tt[0])!
                let x1 = Int(tt[1])!
                arr.swapAt(x0, x1)
                
            } else if s.hasPrefix("p") {
                let p0 = arr.firstIndex(of: tt[0].first!)!
                let p1 = arr.firstIndex(of: tt[1].first!)!
                arr.swapAt(p0, p1)
            }
        }
        let hash = String(arr)
        if seen.contains(hash) {
            return String(history[1_000_000_000 % i]!)
        }
        seen.insert(hash)
        history[i] = hash
    }
    return ""
}
