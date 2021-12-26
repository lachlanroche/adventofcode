import Foundation

func inputData() -> World {
    var data = [[Point]]()
    for s in stringsFromFile() {
        guard s != "" else { continue }
        var row = [Point]()
        for c in s {
            row.append(Point(rawValue: c)!)
        }
        data.append(row)
    }
    return World(data: data)
}

struct World {
    var data: [[Point]]

    var xmod: Int { get { data[0].count }}
    var ymod: Int { get { data.count }}
    
    subscript(x: Int, y: Int) -> Point {
        get {
            return data[y][x]
        }
        set {
            data[y][x] = newValue
        }
    }
}

enum Point: Character {
    case empty = "."
    case east = ">"
    case south = "v"
}

extension World {
    mutating func move() -> Bool {
        var moved = false
        
        var moves = [(Int, Int, Int, Int)]()
        
        for y in 0..<(ymod) {
            for x in 0..<(xmod) {
                let x1 = (x + 1) % xmod
                if self[x, y] == .east && self[x1, y] == .empty {
                    moves.append((x, y, x1, y))
                    moved = true
                }
            }
        }
        
        for m in moves {
            self[m.0, m.1] = .empty
            self[m.2, m.3] = .east
        }
        moves = [(Int, Int, Int, Int)]()
        
        for y in 0..<(ymod) {
            let y1 = (y + 1) % ymod
            for x in 0..<(xmod) {
                if self[x, y] == .south && self[x, y1] == .empty {
                    moves.append((x, y, x, y1))
                    moved = true
                }
            }
        }
        
        for m in moves {
            self[m.0, m.1] = .empty
            self[m.2, m.3] = .south
        }
        
        return moved
    }
    func draw() -> String {
        var s = [Character]()
        
        for y in 0..<ymod {
            for x in 0..<xmod {
                s.append(self[x, y].rawValue)
            }
            s.append("\n")
        }
        return String(s)
    }
}

public func part1() -> Int {
    var world = inputData()

    var step = 1
    while true {
        if !world.move() {
            return step
        }
        step = 1 + step
    }
    return 0
}
