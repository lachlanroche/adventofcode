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

public func knothash(of  str: String) -> [UInt8] {
    let ascii = str.compactMap{ Int($0.asciiValue!) }
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
    return data
}

extension BinaryInteger {
    var hashDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0

        for _ in (1...self.bitWidth) {
            let c: Character
            if 0 == internalNumber & 1 {
                c = " "
            } else {
                c = "#"
            }
            binaryString.insert(c, at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
        }

        return binaryString
    }
}

public func part1() -> Int {
    let input = "hwlqcszp"
    var result = 0
    for i in 0..<128 {
        result += knothash(of: "\(input)-\(i)")
            .map{ $0.hashDescription  }
            .joined()
            .filter{$0 == "#"}
            .count
    }
    return result
}

struct Point: Hashable {
    let x: Int
    let y: Int
    
    func neighbors() -> [Point] {
        return [
            Point(x: x,     y: y + 1),
            Point(x: x,     y: y - 1),
            Point(x: x + 1, y: y),
            Point(x: x - 1, y: y),
        ]
    }
}

struct World {
    var map = Dictionary<Point, Int>()
    
    mutating func paint(_ xy: Point, with color: Int) {
        var seen = Set<Point>()
        var work = Set<Point>()
        work.insert(xy)
        
        while work.count != 0 {
            let p = work.removeFirst()
            map[p] = color
            seen.insert(p)
            for n in p.neighbors() {
                guard let _ = map[n] else { continue }
                guard !seen.contains(n) else { continue }
                work.insert(n)
            }
        }
    }
}

public func part2() -> Int {
    let input = "hwlqcszp"
    var world = World()
    for y in 0..<128 {
        let str = knothash(of: "\(input)-\(y)")
            .map{ $0.hashDescription  }
            .joined()
        var x = 0
        for c in str {
            if c == "#" {
                world.map[Point(x: x, y: y)] = 0
            }
            x += 1
        }
    }
    
    var i = 1
    for k in world.map.keys {
        guard world.map[k] == 0 else { continue }
        world.paint(k, with: i)
        i += 1
    }

    return Set(world.map.values).count
}
