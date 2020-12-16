import Foundation

func react(with input: [Character]) -> Int {
    var arr = input
    
    let delta = Int(Character("a").asciiValue!) - Int(Character("A").asciiValue!)
    var i = 0
    while true {
        guard i + 1 < arr.count else { break }
        let a = arr[i]
        let b = arr[1+i]
        if delta == abs(Int(a.asciiValue!) - Int(b.asciiValue!)) {
            arr.remove(at: i)
            arr.remove(at: i)
            i = max(0, i - 1)
        } else {
            i += 1
        }
    }
    return arr.count
}

public func part1() -> Int {
    return react(with: Array(stringsFromFile(named: "input")[0]))
}

