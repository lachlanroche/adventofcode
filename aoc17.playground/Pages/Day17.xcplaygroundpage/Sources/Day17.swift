import Foundation

public func part1() -> Int {
    var arr = [0]
    var pos = 0
    let step = 337
    for i in 1...2017 {
        pos = (pos + step) % arr.count
        arr.insert(i, at: pos + 1)
        pos = pos + 1
    }
    return arr[(pos + 1) % arr.count]
}
