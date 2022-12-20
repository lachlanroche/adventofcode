import Foundation

func inputData() -> [(i: Int, value: Int)] {
    Array(stringsFromFile().compactMap({ Int($0) }).enumerated().map({ (i: $0, value: $1) }))
}

public func part1() -> Int {
    var list = inputData()
    let length = list.count
    for i in 0..<length {
        guard let index = list.firstIndex(where: { $0.i == i }) else { continue }
        let item = list[index]
        list.remove(at: index)
        let value = item.value
        let extra = value > 0 ? 0 : (length - 1) * (1 + abs(value).quotientAndRemainder(dividingBy: length - 1).quotient)
        let newIndex = (index + value + extra) % (length - 1)
        list.insert(item, at: newIndex)
    }
    if let index = list.firstIndex(where: { $0.value == 0 }) {
        return [1000, 2000, 3000].reduce(0) { $0 + list[(index + $1) % length].value }
    }
    return -1
}

public func part2() -> Int {
    var list = inputData()
    let length = list.count
    for _ in 1...10 {
        for i in 0..<length {
            guard let index = list.firstIndex(where: { $0.i == i }) else { continue }
            let item = list[index]
            list.remove(at: index)
            let value = 811589153 * item.value
            let extra = value > 0 ? 0 : (length - 1) * (1 + abs(value).quotientAndRemainder(dividingBy: length - 1).quotient)
            let newIndex = (index + value + extra) % (length - 1)
            list.insert(item, at: newIndex)
        }
    }
    if let index = list.firstIndex(where: { $0.value == 0 }) {
        return [1000, 2000, 3000].reduce(0) { $0 + 811589153 * list[(index + $1) % length].value }
    }
    return -1
}
