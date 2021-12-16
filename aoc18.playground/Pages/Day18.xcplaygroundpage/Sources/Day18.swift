import Foundation

func inputData() -> World {
    var tree = Set<Point2D>()
    var lumber = Set<Point2D>()
    var y = 0
    for s in stringsFromFile() {
        var x = 0
        for c in s {
            let p = Point2D(x: x, y: y)
            if c == "|" {
                tree.insert(p)
            } else if c == "#" {
                lumber.insert(p)
            }
            x = 1 + x
        }
        y = 1 + y
    }
    return World(tree: tree, lumber: lumber)
}

struct Point2D: Hashable {
    let x: Int
    let y: Int
    
    func neighbors() -> [Point2D] {
        return [
            Point2D(x: x - 1, y: y - 1),
            Point2D(x: x,     y: y - 1),
            Point2D(x: x + 1, y: y - 1),
            Point2D(x: x - 1, y: y),
            Point2D(x: x + 1, y: y),
            Point2D(x: x - 1, y: y + 1),
            Point2D(x: x,     y: y + 1),
            Point2D(x: x + 1, y: y + 1),
        ]
    }
}

struct World {
    let tree: Set<Point2D>
    let lumber: Set<Point2D>
}

func step(tree: inout Set<Point2D>, lumber: inout Set<Point2D>) {
    let openTree = tree
        .flatMap({ $0.neighbors() })
        .filter({ !lumber.contains($0) && !tree.contains($0) })
        .filter({ 0..<50 ~= $0.x && 0..<50 ~= $0.y })
        .reduce(into: [:], { $0[$1] = 1 + $0[$1, default: 0] })
        .compactMap({ $0.value >= 3 ? $0.key : nil })

    let treeLumber = tree.filter {
        Set($0.neighbors()).intersection(lumber).count >= 3
    }

    let lumberOpen = lumber.filter {
        l in
        let neighbors = Set(l.neighbors())
        return neighbors.intersection(tree).isEmpty || neighbors.intersection(lumber).isEmpty
    }

    tree.subtract(treeLumber)
    tree.formUnion(openTree)
    lumber.subtract(lumberOpen)
    lumber.formUnion(treeLumber)
}

func draw(tree: Set<Point2D>, lumber: Set<Point2D>) -> String {
    var s = [Character]()
    for y in 0..<50 {
        for x in 0..<50 {
            let p = Point2D(x: x, y: y)
            if tree.contains(p) {
                s.append("|")
            } else if lumber.contains(p) {
                s.append("#")
            } else {
                s.append(".")
            }
        }
        s.append("\n")
    }
    return String(s)
}

public func part1() -> Int {
    let world = inputData()
    var tree = world.tree
    var lumber = world.lumber

    for i in 0..<10 {
        step(tree: &tree, lumber: &lumber)
    }
    
    return tree.count * lumber.count
}

public func part2() -> Int {
    let world = inputData()
    var tree = world.tree
    var lumber = world.lumber

    var patterns = [String:(Int,Int)]()

    for i in 1..<1000 {
        step(tree: &tree, lumber: &lumber)
        
        let drawn = draw(tree: tree, lumber: lumber)
        if let (t, _) = patterns[drawn] {
            let cycle = i - t
            if 0 == (1_000_000_000 - i) % cycle {
                return tree.count * lumber.count
            }
        }

        patterns[drawn] = (i, tree.count * lumber.count)
        print("\(i) \(tree.count * lumber.count)")
    }
    
    return 0
}
