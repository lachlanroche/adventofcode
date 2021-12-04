import Foundation

struct Board: Hashable {
    let score: Int
    let number: Int
    let count: Int
}

func bingo(numbers: [Int], rows: Array<Array<Int>>) -> Board {
    var lines = Array<Set<Int>>()
    for i in 0...4 {
        let col = [rows[0][i], rows[1][i], rows[2][i], rows[3][i], rows[4][i], ]
        lines.append(Set(col))
        lines.append(Set(rows[i]))
    }
    var values = Set<Int>()
    for l in lines {
        values.formUnion(l)
    }
    
    var seen = Set<Int>()
    var number = 0
    var count = 0
    var score = 0
    for n in numbers {
        guard score == 0 else { break }
        
        number = n
        seen.insert(n)
        values.remove(n)
        
        for line in lines {
            if 5 == line.intersection(seen).count {
                score = values.reduce(0) { $0 + $1 }
            }
        }
        
        count = 1 + count
    }
    
    return Board(score: score, number: number, count: count)
}

func bingoBoards() -> Set<Board> {
    var inputData = stringsFromFile()
    let numbers = inputData[0].components(separatedBy: ",").map {Int($0)!}
    inputData = Array(inputData.dropFirst())
    
    var boards = Set<Board>()
    var rows = Array<Array<Int>>()
    for s in inputData {
        if s == "" && rows.count == 0 {
            continue
        } else if s == "" {
            boards.insert(bingo(numbers: numbers, rows: rows))
            rows = Array<Array<Int>>()
            continue
        }
        
        let row = Array(s.split(separator: " ", omittingEmptySubsequences: true).map {Int($0)!})
        rows.append(row)
    }
    
    return boards
}

public func part1() -> Int {
    let winner = bingoBoards().sorted(by: { $0.count <= $1.count })[0]
    return winner.score * winner.number
}

public func part2() -> Int {
    let winner = bingoBoards().sorted(by: { $0.count > $1.count })[0]
    return winner.score * winner.number
}

//: [Next](@next)
