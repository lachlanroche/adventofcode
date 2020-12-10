import Foundation

public
func inputData() -> Dictionary<Int, [Int]> {
    var result = Dictionary<Int, [Int]>()
    let lines = stringsFromFile(named: "input")
        .filter{ $0 != "" }
        .map({ $0.components(separatedBy: " ") })
    for line in lines {
        let nums = line.compactMap{ Int($0) }
        result[nums[0]] = Array(nums.dropFirst())
    }
    return result
}

public func part1() -> Int {
    let world = inputData()
    var seen = Set<Int>()
    var queue:Set<Int> = [0]
    
    while true {
        guard let node = queue.first else { break }
        queue.remove(node)
        seen.insert(node)
        for next in world[node]! {
            if !seen.contains(next) {
                queue.insert(next)
            }
        }
    }

    return seen.count
}

public func part2() -> Int {
    let world = inputData()
    var seen = Set<Int>()
    var groups = 0
    
    for start in world.keys.sorted() {
        guard !seen.contains(start) else { continue }

        groups += 1
        var queue:Set<Int> = [start]
    
        while true {
            guard let node = queue.first else { break }
            queue.remove(node)
            seen.insert(node)
            for next in world[node]! {
                if !seen.contains(next) {
                    queue.insert(next)
                }
            }
        }
    }

    return groups
}
