import Foundation

func indexOf(row: Int, col: Int) -> Int {
    var maxRow = 1
    var r = 1
    var c = 1
    var i = 1
    
    while true {
        if r == row && c == col {
            return i
        }
        if r == 1 {
            c = 1
            r = 1 + maxRow
            maxRow = r
            
        } else {
            c += 1
            r -= 1
        }
        
        i += 1
    }
}

public func part1() -> Int64 {
    var code: Int64 = 20151125
    for i in 2...indexOf(row: 3010, col: 3019) {
        code *= 252533
        code = code.quotientAndRemainder(dividingBy: 33554393).remainder
    }
    return code
}
