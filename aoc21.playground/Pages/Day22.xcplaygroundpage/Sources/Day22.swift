import Foundation

func inputData() -> [Cube] {
    var result = [Cube]()
    for str in stringsFromFile() {
        guard str.hasPrefix("o") else { continue }
        let on = str.hasPrefix("on")
        
        let s = str.dropFirst(on ? 3 : 4)
        let parts = s.components(separatedBy: ",")
        let xcomp = parts[0].dropFirst(2).components(separatedBy: ".")
        let ycomp = parts[1].dropFirst(2).components(separatedBy: ".")
        let zcomp = parts[2].dropFirst(2).components(separatedBy: ".")
        let x0 = Int(xcomp[0])!
        let x1 = 1 + Int(xcomp[2])!
        let y0 = Int(ycomp[0])!
        let y1 = 1 + Int(ycomp[2])!
        let z0 = Int(zcomp[0])!
        let z1 = 1 + Int(zcomp[2])!
        let cube = Cube(on: on, x0: x0, x1: x1, y0: y0, y1: y1, z0: z0, z1: z1)
        result.append(cube)
    }
    return result
}

struct Cube {
    let on: Bool
    let x0: Int
    let x1: Int
    let y0: Int
    let y1: Int
    let z0: Int
    let z1: Int

    var volume: Int {
        get { (x1 - x0) * (y1 - y0) * (z1 - z0) }
    }

    func contains(cube other: Cube) -> Bool {
        return x0 <= other.x0 && x1 >= other.x1 &&
        y0 <= other.y0 && y1 >= other.y1 &&
        z0 <= other.z0 && z1 >= other.z1
    }
    
    func intersects(cube other: Cube) -> Bool {
        return x0 <= other.x1 && x1 >= other.x0 &&
        y0 <= other.y1 && y1 >= other.y0 &&
        z0 <= other.z1 && z1 >= other.z0
    }
    
    func subtract(cube other: Cube) -> [Cube] {
        if other.contains(cube: self) {
            return []
        }
        if !intersects(cube: other) {
            return [self]
        }

        var xx = [other.x0, other.x1].filter { x0 < $0 && $0 < x1 }
        var yy = [other.y0, other.y1].filter { y0 < $0 && $0 < y1 }
        var zz = [other.z0, other.z1].filter { z0 < $0 && $0 < z1 }
        xx.insert(x0, at: 0)
        xx.append(x1)
        yy.insert(y0, at: 0)
        yy.append(y1)
        zz.insert(z0, at: 0)
        zz.append(z1)
        
        var result = [Cube]()
        for i in 0..<(xx.count - 1)  {
            for j in 0..<(yy.count - 1)  {
                for k in 0..<(zz.count - 1)  {
                    let cube = Cube(on: on, x0: xx[i], x1: xx[i+1], y0: yy[j], y1: yy[j+1], z0: zz[k], z1: zz[k+1])
                    result.append(cube)
                }
            }
        }

        return result.filter { !other.contains(cube: $0) }
    }
}

struct Point3D: Hashable, Equatable {
    let x: Int
    let y: Int
    let z: Int
}

public func part1() -> Int {
    var world = Set<Point3D>()
    let target = -50..<51
    for cube in inputData() {
        let xrange = ((cube.x0)..<(cube.x1)).clamped(to: target)
        let yrange = ((cube.y0)..<(cube.y1)).clamped(to: target)
        let zrange = ((cube.z0)..<(cube.z1)).clamped(to: target)
        
        guard  !xrange.isEmpty && !yrange.isEmpty && !zrange.isEmpty else { continue }
        for x in xrange {
            for y in yrange {
                for z in zrange {
                    let p = Point3D(x: x, y: y, z: z)
                    if cube.on {
                        world.insert(p)
                    } else {
                        world.remove(p)
                    }
                }
            }
        }
    }
    return world.count
}

public func part2() -> Int {
    var world = [Cube]()
        
    for c in inputData() {
        world = world.flatMap { $0.subtract(cube: c) }
        if c.on {
            world.append(c)
        }
    }
    
    return world.reduce(0) { $0 + $1.volume }
}

