import Foundation

// target area: x=155..182, y=-117..-67

func fire(vx vx0: Int, vy vy0: Int, maxy maxy0: inout Int) -> Bool {
    
    var vx = vx0
    var vy = vy0
    var x = 0
    var y = 0
    var maxy = 0
    while true {
        x = x + vx
        y = y + vy
        vx = max(0, vx - 1)
        vy = vy - 1
        maxy = max(y, maxy)
        if 155...182 ~= x && -117...(-67) ~= y {
            // print("\(x),\(y) \(maxy)")
            // print("ok")
            break
        }
        if vx == 0 && x < 155 {
            return false
        }
        if y < -117  || x > 182 {
            return false
        }
    }
    
    maxy0 = max(maxy0, maxy)
    return true
}

public func part1() -> Int {
    var maxy = 0
    for vy in 0..<127 {
        for vx in 17...18 {
            fire(vx: vx, vy: vy, maxy: &maxy)
        }
    }
    return maxy
}

