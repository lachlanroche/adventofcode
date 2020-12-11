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

