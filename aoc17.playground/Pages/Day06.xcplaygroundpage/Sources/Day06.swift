import Foundation


func inputData() -> [Int] {
    return [14, 0, 15, 12, 11, 11, 3, 5, 1, 6, 8, 4, 9, 1, 8, 4]
}

public func part1() -> Int {
    func reallocate() {
        let size = ram.count
        var max = 0
        var n = 0
        for i in 0..<size {
            if ram[i] > max {
                max = ram[i]
                n = i
            }
        }
        
        var blocks = ram[n]
        ram[n] = 0
        
        while blocks > 0 {
            n = (1 + n) % size
            ram[n] += 1
            blocks -= 1
        }
    }
    
    var ram = inputData()
    
    var seen: Set<String> = []
    seen.insert(ram.description)
    var i = 1
    while true {
        reallocate()
        
        let hash = ram.description
        guard !seen.contains(hash) else { return i }
        seen.insert(hash)
        i += 1
    }
}

public func part2() -> Int {
    func reallocate() {
        let size = ram.count
        var max = 0
        var n = 0
        for i in 0..<size {
            if ram[i] > max {
                max = ram[i]
                n = i
            }
        }
        
        var blocks = ram[n]
        ram[n] = 0
        
        while blocks > 0 {
            n = (1 + n) % size
            ram[n] += 1
            blocks -= 1
        }
    }
    
    var ram = inputData()
    
    var seen: Dictionary<String, Int> = [:]
    seen[ram.description] = 0
    var i = 1
    while true {
        reallocate()
        
        let hash = ram.description
        guard nil == seen[hash] else { return 1 + i - seen[hash]! }
        i += 1
        seen[hash] = i
    }
}
