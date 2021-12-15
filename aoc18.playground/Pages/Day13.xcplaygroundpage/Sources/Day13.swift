import Foundation

struct Point2D: Hashable, Equatable {
    var x: Int
    var y: Int
}

enum Direction: Character {
    case up = "^"
    case dn = "v"
    case left = "<"
    case right = ">"
}

enum Turn: Int {
    case left = 0
    case fwd = 1
    case right = 2
}

struct Cart {
    var coord: Point2D
    var dir: Direction
    var turn = Turn.left
    
    init(coord: Point2D, dir: Direction) {
        self.coord = coord
        self.dir = dir
    }
}

extension Point2D {
    mutating func move(_ dir: Direction) {
        switch dir {
        case .up: y = y - 1; break
        case .dn: y = y + 1; break
        case .left: x = x - 1; break
        case .right: x = x + 1; break
        }
    }
}

extension Cart {
    mutating func move(in world: Dictionary<Point2D,Character>) {
        guard let ch = world[coord] else { return }
        switch ch {
        case "|":
            coord.move(dir)
            break
        case "-":
            coord.move(dir)
            break
        case "+":
            steer()
            coord.move(dir)
            break
        case "\\":
            corner(ch)
            coord.move(dir)
            break
        case "/":
            corner(ch)
            coord.move(dir)
            break
        default:
            break
        }
    }
    mutating func corner(_ ch: Character) {
        switch (dir, ch) {
        case (.left, "/"): dir = .dn; break
        case (.left, "\\"): dir = .up; break
        case (.right, "/"): dir = .up; break
        case (.right, "\\"): dir = .dn; break
        case (.up, "/"): dir = .right; break
        case (.up, "\\"): dir = .left; break
        case (.dn, "/"): dir = .left; break
        case (.dn, "\\"): dir = .right; break
        default: break
        }
    }
    mutating func steer() {
        switch (turn, dir) {
        case (.left, .up): dir = .left; break
        case (.left, .left): dir = .dn; break
        case (.left, .dn): dir = .right; break
        case (.left, .right): dir = .up; break
        case (.right, .up): dir = .right; break
        case (.right, .left): dir = .up; break
        case (.right, .dn): dir = .left; break
        case (.right, .right): dir = .dn; break
        case (.fwd, _): break
        }
        turn = Turn(rawValue: (1 + turn.rawValue) % 3)!
    }
}

func inputData() -> (world: Dictionary<Point2D,Character>, carts: [Cart]) {
    var world = Dictionary<Point2D,Character>()
    var carts = [Cart]()
    var y = 0
    
    for str in stringsFromFile() {
        guard str != "" else { continue }
        var x = 0
        for ch in str {
            var tch = ch
            if ch == "^" || ch == "v" {
                tch = "|"
            } else if ch == "<" || ch == ">" {
                tch = "-"
            }
            let coord = Point2D(x: x, y: y)
            if tch != ch {
                carts.append(Cart(coord: coord, dir: Direction(rawValue: ch)!))
            }
            world[coord] = tch

            x = 1 + x
        }
        y = 1 + y
    }
    
    return (world: world, carts: carts)
}

func tick1(world: Dictionary<Point2D,Character>, carts cartsOriginal: [Cart]) -> ([Cart], Point2D?) {
    
    var collision: Point2D? = nil
    var carts = cartsOriginal.sorted(by: { $0.coord.y < $1.coord.y || $0.coord.x < $1.coord.x })
    var cartsNew = [Cart]()
    var coords = Set(carts.map {$0.coord})
    for var c in Array(carts.sorted(by: {a, b in a.coord.x < b.coord.x || a.coord.y < b.coord.y})) {
        
        coords.remove(c.coord)
        c.move(in: world)
        if coords.contains(c.coord) && collision == nil {
            collision = c.coord
        }
        coords.insert(c.coord)
        cartsNew.append(c)
    }
    
    return (cartsNew, collision)
}

public func part1() -> String {
    let data = inputData()
    let world = data.world
    var carts = data.carts

    while (true) {
        let next = tick1(world: world, carts: carts)
        if let collision = next.1 {
            return "\(collision.x),\(collision.y)"
        }
        carts = next.0
    }
    
    return ""
}

func tick2(world: Dictionary<Point2D,Character>, carts cartsOriginal: [Cart]) -> ([Cart], Point2D?) {
    
    let carts = cartsOriginal
    var cartsNew = [Cart]()
    var coords = Set(carts.map {$0.coord})
    var collisions = Set<Point2D>()
    for var c in Array(carts.sorted(by: {a, b in a.coord.x < b.coord.x || a.coord.y < b.coord.y})) {
        
        coords.remove(c.coord)
        if collisions.contains(c.coord) {
            continue
        }
        c.move(in: world)
        if coords.contains(c.coord) {
            collisions.insert(c.coord)
            continue
        }
        coords.insert(c.coord)
        cartsNew.append(c)
    }
    
    return (cartsNew.filter({ !collisions.contains($0.coord) }), collisions.first)
}

public func part2() -> String {
    let data = inputData()
    let world = data.world
    var carts = data.carts

    while (true) {
        let next = tick2(world: world, carts: carts)
        if next.0.count == 1 {
            let last = next.0[0].coord
            return "\(last.x),\(last.y)"
        }
        carts = next.0
    }
    
    return ""
}
