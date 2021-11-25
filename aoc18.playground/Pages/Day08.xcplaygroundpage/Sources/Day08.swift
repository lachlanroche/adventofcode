import Foundation

func inputData() -> [Int] {
    return numbersFromString(stringFromFile(), sep: " \n\t")
}

public func part1() -> Int {
    let data = inputData()
    var i = 0
    var metaSum = 0

    func node() {
        let nodes = data[i]
        let metadata = data[i+1]
        i = i + 2
        
        if nodes > 0 {
            for _ in 1...nodes {
                node()
            }
        }
        if metadata > 0 {
            for _ in 1...metadata {
                metaSum = metaSum + data[i]
                i = 1 + i
            }
        }
    }
    
    node()
    
    return metaSum
}
