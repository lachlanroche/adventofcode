import Foundation


public func part1() -> Int {
    var list = Array(0..<256)
    var lengths = [183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88]
    var position = 0
    var skip = 0

    for len in lengths {
        var arr = list
        for i in 0..<len {
            let to = (i + position) % 256
            let from = (position + len - 1 - i) % 256
            arr[to] = list[from]
        }
        list = arr

        position += len + skip
        position %= 256
        skip += 1
    }

    return list[0] * list[1]
}
