import Foundation


func inputData() -> [Scanner] {
    var result = [Scanner]()
    var id = -1
    var scanner = Scanner(id: 0)
    var points = [Point3D]()
    for str in stringsFromFile() {
        if str == "" {
            if id >= 0 && !points.isEmpty {
                scanner.points = points
                result.append(scanner)
                points = [Point3D]()
            }
        } else if str.hasPrefix("---") {
            scanner = Scanner(id: id)
            id = 1 + id
        } else {
            let parts = str.components(separatedBy: ",")
            let x = Int(parts[0])!
            let y = Int(parts[1])!
            let z = Int(parts[2])!
            points.append(Point3D(x: x, y: y, z: z))
        }
    }
    
    return result
}

struct Scanner {
    var id: Int
    var points = [Point3D]()
    var diffs = [Set<Int>:[Point3D]]()
    var origin = Point3D(x: 0, y: 0, z: 0)
    
    
    mutating func align(with other: Scanner) -> Bool {
        
        for rot in 0...23 {
            let rotated = points.map { $0.rotation(rot) }
            var offsets = [Point3D:Int]()
            
            for op in rotated {
                for tp in other.points {
                    var offset = tp.subtract(op)
                    offsets[offset] = 1 + offsets[offset, default: 0]
                }
            }
            
            offsets = offsets.filter { k, v in v >= 12 }
            guard !offsets.isEmpty else { continue }

            let (delta,_) = offsets.first!
            origin = delta
            points = rotated.map { origin.add($0) }
            return true
        }
        return false
    }
}

struct Point3D: Hashable, Equatable {
    let x: Int
    let y: Int
    let z: Int
    
    func add(_ p: Point3D) -> Point3D {
        Point3D(x: x + p.x, y: y + p.y, z: z + p.z)
    }
    
    func subtract(_ p: Point3D) -> Point3D {
        Point3D(x: x - p.x, y: y - p.y, z: z - p.z)
    }
    
    func manhattan(to p: Point3D) -> Int {
        return abs(x - p.x) + abs(y - p.y) + abs (z - p.z)
    }
    
    func rotation(_ i: Int) -> Point3D {
        switch (i) {
            // rotate around x axis
        case 0: return Point3D(x: x, y: y, z: z)
        case 1: return Point3D(x: x, y: z, z: -y)
        case 2: return Point3D(x: x, y: -y, z: -z)
        case 3: return Point3D(x: x, y: -z, z: y)
            // rotate around y axis
        case 4: return Point3D(x: -y, y: x, z: z)
        case 5: return Point3D(x: -z, y: x, z: -y)
        case 6: return Point3D(x: y, y: x, z: -z)
        case 7: return Point3D(x: z, y: x, z: y)
            // rotate around z axis
        case 8: return Point3D(x: -z, y: y, z: x)
        case 9: return Point3D(x: y, y: z, z: x)
        case 10: return Point3D(x: z, y: -y, z: x)
        case 11: return Point3D(x: -y, y: -z, z: x)
            // rotate around -x axis
        case 12: return Point3D(x: -x, y: y, z: -z)
        case 13: return Point3D(x: -x, y: z, z: y)
        case 14: return Point3D(x: -x, y: -y, z: z)
        case 15: return Point3D(x: -x, y: -z, z: -y)
            // rotate around -y axis
        case 16: return Point3D(x: y, y: -x, z: z)
        case 17: return Point3D(x: -z, y: -x, z: y)
        case 18: return Point3D(x: -y, y: -x, z: -z)
        case 19: return Point3D(x: z, y: -x, z: -y)
            // rotate around -z axis
        case 20: return Point3D(x: z, y: y, z: -x)
        case 21: return Point3D(x: y, y: -z, z: -x)
        case 22: return Point3D(x: -z, y: -y, z: -x)
        case 23: return Point3D(x: -y, y: z, z: -x)
            // never
        default: return Point3D(x: 0, y: 0, z: 0)
        }
    }
}

public func part1() -> Int {
    var unknown = inputData()
    var adjusted = [unknown.removeFirst()]

    while !unknown.isEmpty {
        var u = unknown.removeFirst()
        var found = false
        
        for k in adjusted {
            if u.align(with: k) {
                adjusted.append(u)
                found = true
                break
            }
        }
        
        if !found {
            unknown.append(u)
        }
    }
    
    var world = Set<Point3D>()
    for a in adjusted {
        world.formUnion(a.points)
    }

    return world.count
}

public func part2() -> Int {
    var unknown = inputData()
    var adjusted = [unknown.removeFirst()]
    while !unknown.isEmpty {
        var u = unknown.removeFirst()
        var found = false
        
        for k in adjusted {
            if u.align(with: k) {
                adjusted.append(u)
                found = true
                break
            }
        }
        
        if !found {
            unknown.append(u)
        }
    }
    
    var maxDistance = 0
    for a in adjusted {
        for b in adjusted {
            let distance = a.origin.manhattan(to: b.origin)
            maxDistance = max(maxDistance, distance)
        }
    }

    return maxDistance
}
