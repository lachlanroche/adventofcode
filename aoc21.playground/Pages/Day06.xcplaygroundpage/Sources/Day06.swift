import Foundation


func inputData() -> [Int] {
    return [1,1,3,1,3,2,1,3,1,1,3,1,1,2,1,3,1,1,3,5,1,1,1,3,1,2,1,1,1,1,4,4,1,2,1,2,1,1,1,5,3,2,1,5,2,5,3,3,2,2,5,4,1,1,4,4,1,1,1,1,1,1,5,1,2,4,3,2,2,2,2,1,4,1,1,5,1,3,4,4,1,1,3,3,5,5,3,1,3,3,3,1,4,2,2,1,3,4,1,4,3,3,2,3,1,1,1,5,3,1,4,2,2,3,1,3,1,2,3,3,1,4,2,2,4,1,3,1,1,1,1,1,2,1,3,3,1,2,1,1,3,4,1,1,1,1,5,1,1,5,1,1,1,4,1,5,3,1,1,3,2,1,1,3,1,1,1,5,4,3,3,5,1,3,4,3,3,1,4,4,1,2,1,1,2,1,1,1,2,1,1,1,1,1,5,1,1,2,1,5,2,1,1,2,3,2,3,1,3,1,1,1,5,1,1,2,1,1,1,1,3,4,5,3,1,4,1,1,4,1,4,1,1,1,4,5,1,1,1,4,1,3,2,2,1,1,2,3,1,4,3,5,1,5,1,1,4,5,5,1,1,3,3,1,1,1,1,5,5,3,3,2,4,1,1,1,1,1,5,1,1,2,5,5,4,2,4,4,1,1,3,3,1,5,1,1,1,1,1,1]
}

public func part1() -> Int {
    var fish = inputData()
    
    for i in 1...80 {
        let eights = fish.filter { $0 == 0 }.count
        fish = fish.map { $0 == 0 ? 6 : $0 - 1 }
        fish.append(contentsOf: Array(repeating: 8, count: eights))
    }
    
    return fish.count
}

public func quickFish(_ days: Int) -> Int {
    var data = inputData()
    var fish = [Int]()
    
    for i in 0..<9 {
        fish.append(data.filter {$0 == i}.count)
    }
    
    for i in 0..<days {
        var newFish = fish
        newFish.remove(at: 0)
        newFish.append(fish[0])
        newFish[6] = newFish[6] + fish[0]
        
        fish = newFish
    }
    
    return fish.reduce(0) { $0 + $1 }
}

public func part2() -> Int {
    return quickFish(256)
}
