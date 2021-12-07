import Foundation

public func part1() -> (x: Int, y: Int) {
    let serial = 6548
    var result = (x: 0, y: 0)
    var maxWatts = -1_000_000
    
    for x in 0..<297 {
        for y in 0..<297 {
            let p = (x: x, y: y)
            var watts = 0
            
            for px in 0..<3 {
                for py in 0..<3 {
                    let c = (x: p.x + px, y: p.y + py)
                    let rackId = c.x + 10
                    var cell = rackId * c.y
                    cell = cell + serial
                    cell = cell * rackId
                    cell = cell / 100
                    cell = cell % 10
                    cell = cell - 5
                    watts = watts + cell
                }
            }
            
            if watts > maxWatts {
                maxWatts = watts
                result = p
            }
        }
    }
    
    return result
}

public func part2() -> (x: Int, y: Int, w: Int) {
    let serial = 6548
    var psum = Array(repeating: Array(repeating: 0, count: 301), count: 301)
    
    for cy in 1...300 {
        for cx in 1...300 {
            let rackId = cx + 10
            var cell = rackId * cy
            cell = cell + serial
            cell = cell * rackId
            cell = cell / 100
            cell = cell % 10
            cell = cell - 5
            psum[cy][cx] = cell + psum[cy - 1][cx] + psum[cy][cx - 1] - psum[cy - 1][cx - 1]
        }
    }
    
    var result = (x: 0, y: 0, w: 0)
    var maxWatts = -Int.max
    for w in 1...300 {
        for y in w...300 {
            for x in w...300 {
                var watts = psum[y][x] - psum[y - w][x] - psum[y][x - w] + psum[y - w][x - w]
                
                if watts > maxWatts {
                    maxWatts = watts
                    result = (x: x - w + 1, y: y - w + 1, w: w)
                }
            }
        }
    }
    
    return result
}
