//: [Previous](@previous)

import Foundation

func inputstring() -> String {
    let url = Bundle.main.url(forResource: "input02", withExtension: "txt")
    let data = try? Data(contentsOf: url!)
    return String(data: data!, encoding: .utf8)!
}

struct Size {
    let width, length, height: Int
    
    init(sides: [Int?]) {
        width = sides[0]!
        height = sides[1]!
        length = sides[2]!
    }
}

func inputdata() -> [Size]
{
    return inputstring()
        .components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .map { $0.components(separatedBy: "x").map(Int.init) }
        .map(Size.init)
}

extension Size {
    var papersize: Int {
        get {
            let sides = [width*height, width*length, height*length].sorted()
            
            return sides.reduce(sides[0]) { (acc, side) in
                return acc + 2 * side
            }
        }
    }
}

func part1() -> Int
{
    return inputdata().reduce(0) { (acc,size) in
        return acc + size.papersize
    }
}

Size(sides: [2, 3, 4]).papersize
Size(sides: [1, 1, 10]).papersize
part1()
//: [Next](@next)
