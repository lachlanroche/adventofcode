import Foundation

func inputData() -> Map {
    var file = stringsFromFile()
    let rule = file[0].map { $0 == "#" ? 1 : 0 }
    file.removeFirst(2)
    var image = [Point2D:Int]()
    var y = 0
    for str in file {
        guard str != "" else { continue }
        var x = 0
        for ch in str {
            let p = Point2D(x: x, y: y)
            image[p] = ch == "#" ? 1 : 0
            x = x + 1
        }
        y = y + 1
    }

    return Map(rule: rule, image: image)
}

struct Point2D: Hashable {
    let x: Int
    let y: Int
    
    func patch() -> [Point2D] {
        return [
            Point2D(x: x - 1, y: y - 1),
            Point2D(x: x, y: y - 1),
            Point2D(x: x + 1, y: y - 1),
            
            Point2D(x: x - 1, y: y),
            Point2D(x: x, y: y),
            Point2D(x: x + 1, y: y),
            
            Point2D(x: x - 1, y: y + 1),
            Point2D(x: x, y: y + 1),
            Point2D(x: x + 1, y: y + 1),
        ]
    }
}

struct Map {
    let rule: [Int]
    var image: Dictionary<Point2D,Int>
    var field = 0
    var minBound = -2
    var maxBound = 101
    
    func enhance(point: Point2D) -> Int {
        var index = 0
        for n in point.patch() {
            index = index * 2 + image[n, default: field]
        }
        return rule[index]
    }

    mutating func enhance() {
        var newImage = image
        for y in minBound...maxBound {
            for x in minBound...maxBound {
                let p = Point2D(x: x, y: y)
                newImage[p] = enhance(point: p)
            }
        }
        field = (field == 0) ? 1 : 0
        minBound = minBound - 1
        maxBound = maxBound + 1
        image = newImage
    }
    
    func draw() -> String {
        var s = ""
        for y in minBound...maxBound {
            for x in minBound...maxBound {
                if image[Point2D(x: x, y: y), default: 0] == 1 {
                    s.append("#")
                } else {
                    s.append(".")
                }
            }
            s.append("\n")
        }

        return s
    }
}

public func part1() -> Int {
    var data = inputData()
    data.enhance()
    data.enhance()
    return data.image.values.reduce(0, +)
}

