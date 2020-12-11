import Foundation


public func part1() -> Int {
    var a: Int64 = 722
    var b: Int64 = 354
    var mask: Int64 = 65535
    var count = 0
    for i in 0..<40_000_000 {
        a = (a * Int64(16807)).quotientAndRemainder(dividingBy: Int64(2147483647)).remainder
        b = (b * Int64(48271)).quotientAndRemainder(dividingBy:Int64(2147483647)).remainder
        if a & mask == b & mask {
            count += 1
        }
    }
    return count
}

struct Generator {
    var i: Int64
    let factor: Int64
    let divisor: Int64
}

extension Generator {
    mutating func step() {
        repeat {
            i = (i * Int64(factor)).quotientAndRemainder(dividingBy: Int64(2147483647)).remainder
        } while 0 != i % divisor
    }
    func matches(_ g: Generator) -> Bool {
        return i & 65535 == g.i & 65535
    }
}

public func part2() -> Int {
    var a = Generator(i:722, factor: 16807, divisor: 4)
    var b = Generator(i:354, factor: 48271, divisor: 8)
    var count = 0
    for i in 0..<5_000_000 {
        a.step()
        b.step()
        if a.matches(b) {
            count += 1
        }
    }
    return count
}
