import Foundation

func inputData() -> [[Int]] {
    return [
        [7,3,1,3,5,1,1,5,5,1],
        [3,7,2,4,8,5,5,8,6,7],
        [2,3,7,4,3,3,1,5,7,1],
        [4,4,3,8,2,1,3,4,3,7],
        [6,5,1,1,5,6,6,2,8,7],
        [6,7,2,7,2,4,5,5,3,2],
        [3,7,3,6,8,6,8,6,6,2],
        [2,3,4,8,1,3,8,2,6,3],
        [2,4,1,7,4,8,3,1,2,1],
        [8,8,1,2,6,1,7,1,1,2]
    ]
}

struct Point2D {
    let x: Int
    let y: Int
}

extension Point2D {
    func neighbors() -> [Point2D] {
        var result = [Point2D]()
        
        for dy in -1...1 {
            for dx in -1...1 {
                guard dx != 0 || dy != 0  else { continue }
                let x = self.x + dx
                let y = self.y + dy
                guard x >= 0 && x < 10 else { continue }
                guard y >= 0 && y < 10 else { continue }
                result.append(Point2D(x: x, y: y))
            }
        }
        
        return result
    }
}

func step( _ world: inout [[Int]]) -> Int {

    var flashes = [Point2D]()
    for y0 in 0..<10 {
        for x0 in 0..<10 {
            world[y0][x0] = 1 + world[y0][x0]
            if world[y0][x0] == 10 {
                flashes.append(Point2D(x: x0, y: y0))
            }
        }
    }

    var result = 0
    while !flashes.isEmpty {
        result = result + flashes.count
        var nextFlashes = [Point2D]()
        for p in flashes {
            for q in p.neighbors() {
                world[q.y][q.x] = 1 + world[q.y][q.x]
                if world[q.y][q.x] == 10 {
                    nextFlashes.append(q)
                }
            }
        }
        flashes = nextFlashes
    }
    
    for yn in 0..<10 {
        for xn in 0..<10 {
            if world[yn][xn] > 9 {
                world[yn][xn] = 0
            }
        }
    }
    return result
}

public func part1() -> Int {
    var world = inputData()

    var result = 0
    for i in 0..<100 {
        result = result + step(&world)
    }
    return result
}

public func part2() -> Int {
    var world = inputData()
    for i in 1...Int.max {
        if 100 == step(&world) {
            return i
        }
    }
    return 0
}
