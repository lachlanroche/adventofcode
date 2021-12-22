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

