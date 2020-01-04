import Foundation

public func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input06", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

struct World {
    var lights: [Bool]
    var width: Int
    var height: Int
    
    init(width: Int, height: Int) {
        self.height = height
        self.width = width
        lights = Array<Bool>(repeating: false, count: width * height)
    }
}

extension World {
    subscript(x: Int, y: Int) -> Bool {
        get {
            return lights[y * width + x]
        }
        set {
            lights[y * width + x] = newValue
        }
    }
    
    mutating func adjust(x1: Int, y1: Int, x2: Int, y2: Int, action: ((Bool) -> Bool)) {
        for x in x1...x2 {
            for y in y1...y2 {
                self[x,y] = action(self[x,y])
            }
        }
    }
    
    mutating func turnOn(x1: Int, y1: Int, x2: Int, y2: Int) {
        adjust(x1: x1, y1: y1, x2: x2, y2: y2) { _ in
            return true
        }
    }
    
    mutating func turnOff(x1: Int, y1: Int, x2: Int, y2: Int) {
        adjust(x1: x1, y1: y1, x2: x2, y2: y2) { _ in
            return false
        }
    }
    
    mutating func toggle(x1: Int, y1: Int, x2: Int, y2: Int) {
        adjust(x1: x1, y1: y1, x2: x2, y2: y2) { oldValue in
            return !oldValue
        }
    }
    
    var onCount: Int {
        return lights.reduce(0) {
            (acc, light) in
            return acc + (light ? 1 : 0)
        }
    }
}

/*
 turn off 446,432 through 458,648
 turn on 715,871 through 722,890
 toggle 424,675 through 740,862
*/

public func part1() -> Int {
    var world = World(width: 1000, height: 1000)
    
    for s in inputstring().components(separatedBy: "\n") {
        let xys: [Int] = s.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }
            .flatMap(Int.init)
        
        if s.hasPrefix("turn off") {
            world.turnOff(x1: xys[0], y1: xys[1], x2: xys[2], y2: xys[3])
            
        } else if s.hasPrefix("turn on") {
            world.turnOn(x1: xys[0], y1: xys[1], x2: xys[2], y2: xys[3])
                
        } else if s.hasPrefix("toggle") {
            world.toggle(x1: xys[0], y1: xys[1], x2: xys[2], y2: xys[3])
        }
    }
    
    return world.onCount
}

struct BrightWorld {
    var lights: [Int]
    var width: Int
    var height: Int
    
    init(width: Int, height: Int) {
        self.height = height
        self.width = width
        lights = Array<Int>(repeating: 0, count: width * height)
    }
}

extension BrightWorld {
    subscript(x: Int, y: Int) -> Int {
        get {
            return lights[y * width + x]
        }
        set {
            lights[y * width + x] = newValue
        }
    }
    
    mutating func adjust(x1: Int, y1: Int, x2: Int, y2: Int, action: ((Int) -> Int)) {
        for x in x1...x2 {
            for y in y1...y2 {
                self[x,y] = action(self[x,y])
            }
        }
    }
    
    mutating func turnOn(x1: Int, y1: Int, x2: Int, y2: Int) {
        adjust(x1: x1, y1: y1, x2: x2, y2: y2) { px in
            return 1 + px
        }
    }
    
    mutating func turnOff(x1: Int, y1: Int, x2: Int, y2: Int) {
        adjust(x1: x1, y1: y1, x2: x2, y2: y2) { px in
            return max(0, px - 1)
        }
    }
    
    mutating func toggle(x1: Int, y1: Int, x2: Int, y2: Int) {
        adjust(x1: x1, y1: y1, x2: x2, y2: y2) { px in
            return px + 2
        }
    }
    
    var brightness: Int {
        return lights.reduce(0) {
            (acc, light) in
            return acc + light
        }
    }
}

public func part2() -> Int {
    var world = BrightWorld(width: 1000, height: 1000)
    
    for s in inputstring().components(separatedBy: "\n") {
        let xys: [Int] = s.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }
            .flatMap(Int.init)
        
        if s.hasPrefix("turn off") {
            world.turnOff(x1: xys[0], y1: xys[1], x2: xys[2], y2: xys[3])
            
        } else if s.hasPrefix("turn on") {
            world.turnOn(x1: xys[0], y1: xys[1], x2: xys[2], y2: xys[3])
                
        } else if s.hasPrefix("toggle") {
            world.toggle(x1: xys[0], y1: xys[1], x2: xys[2], y2: xys[3])
        }
    }
    
    return world.brightness
}
