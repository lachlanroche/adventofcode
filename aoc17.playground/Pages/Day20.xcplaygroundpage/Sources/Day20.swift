import Foundation

func inputData() -> [Particle] {
    var result = [Particle]()
    var i = 0
    for s in stringsFromFile(named: "input") {
        guard s != "" else { continue }
        let pva = s.components(separatedBy: " ")
        let p = pva[0].components(separatedBy: ",")
        let v = pva[1].components(separatedBy: ",")
        let a = pva[2].components(separatedBy: ",")
        let pos = Point(x: Int(p[0])!, y: Int(p[1])!, z: Int(p[2])!)
        let acc = Point(x: Int(a[0])!, y: Int(a[1])!, z: Int(a[2])!)
        let vel = Point(x: Int(v[0])!, y: Int(v[1])!, z: Int(v[2])!)
        result.append(Particle(id: i, pos: pos, acc: acc, vel: vel))
        i += 1
    }
    return result
}

struct Particle {
    let id: Int
    var pos: Point
    var acc: Point
    var vel: Point
    var alive = true
}

struct Point: Hashable {
    var x: Int
    var y: Int
    var z: Int
}

extension Particle {
    mutating func step() {
        vel.x += acc.x
        vel.y += acc.y
        vel.z += acc.z
        pos.x += vel.x
        pos.y += vel.y
        pos.z += vel.z
    }
    
    func dist() -> Int {
        return abs(pos.x) + abs(pos.y) + abs(pos.z)
    }
}

public func part1() -> Int {
    var particles = inputData()
    
    for _ in 0..<10_000 {
        for i in 0..<particles.count {
            particles[i].step()
        }
    }
    
    var dist = 1_000_000_000
    var result = 0
    for i in 0..<particles.count {
        if particles[i].dist() < dist {
            result = i
            dist = particles[i].dist()
        }
    }
    
    return result
}

public func part2() -> Int {
    var particles = inputData()
    
    for _ in 0..<100_000 {
        var places = Dictionary<Point, Int>()
        for i in 0..<particles.count {
            particles[i].step()
            if let j = places[particles[i].pos] {
                particles[i].alive = false
                particles[j].alive = false
            } else {
                places[particles[i].pos] = i
            }
        }
        
        particles = particles.filter{ $0.alive }
    }
    
    return particles.count
}
