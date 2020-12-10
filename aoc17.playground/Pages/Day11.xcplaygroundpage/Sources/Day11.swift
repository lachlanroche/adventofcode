import Foundation

struct Point {
    var x: Int
    var y: Int
}

extension Point {
    mutating func n() {
        y += 2
    }
    mutating func nw() {
        x += 1
        y += 1
    }
    mutating func ne() {
        x -= 1
        y += 1
    }
    mutating func s() {
        y -= 2
    }
    mutating func sw() {
        x += 1
        y -= 1
    }
    mutating func se() {
        x -= 1
        y -= 1
    }
    
}

func walk() -> [Point] {
    var path = [Point]()
    var point = Point(x:0, y:0)
    for step in stringsFromFile(named: "input")[0].components(separatedBy: ",") {
        switch step {
            case "n":
                point.n()
                break
            case "nw":
                point.nw()
                break
            case "ne":
                point.ne()
            break
            case "s":
                point.s()
                break
            case "sw":
                point.sw()
                break
            case "se":
                point.se()
                break
            default:
            break
        }
        path.append(point)
    }
    return path
}

public func part1() -> Int {
    let point = walk().last!
    return (abs(point.x) + abs(point.y)) / 2
}

public func part2() -> Int {
    return walk().map{ (abs($0.x) + abs($0.y)) / 2 }.reduce(0, max)
}
