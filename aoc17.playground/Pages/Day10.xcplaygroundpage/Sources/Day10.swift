import Foundation


func hash(_ lengths: [Int]) -> [Int] {
    var list = Array(0..<256)
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

    return list
}

public func part1() -> Int {
    let list = hash([183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88])
    return list[0] * list[1]
}

public func part2() -> String {
    let ascii = "183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88".compactMap{ Int($0.asciiValue!) }
    var arr = [Int]()
    for _ in 0..<64 {
        arr.append(contentsOf: ascii)
        arr.append(contentsOf: [17, 31, 73, 47, 23])
    }
    var list = hash(arr)
    var data = [UInt8]()
    while list.count != 0 {
        let prefix = list.prefix(upTo: 16)
        list.removeFirst(16)
        let knot = prefix.reduce(into: 0) { (acc, n) in
            acc ^= n
        }
        data.append(UInt8( knot & 255 ))
    }
    return data.map{ String(format: "%02hhx", $0) }.joined()
}
