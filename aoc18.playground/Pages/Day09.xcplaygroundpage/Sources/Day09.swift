import Foundation

let ELF = 468
let MARBLE = 71843

func game(marbles: Int = MARBLE) -> Int {
    var scores = Dictionary<Int,Int>()
    var circle = [0]
    var current = 1
    var elf = 1
    
    for m in 1...marbles {
        if 0 == m % 23 {
            var pos = (current + circle.count - 7) % circle.count
            if pos == circle.count - 1 {
                current = 0
            } else {
                current = pos
            }
            let mr = circle.remove(at: pos)
            scores[elf] = m + mr + (scores[elf] ?? 0)
            
        } else {
            var pos = current
            pos = (current + 1) % circle.count
            current = pos + 1
            circle.insert(m, at: current)
        }
        
        elf = (1 + elf) % ELF
    }
    
    return scores.values.max()!
}

public func part1() -> Int {
    return game()
}

public func part2() -> Int {
    return game(marbles: 100 * MARBLE)
}
