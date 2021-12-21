import Foundation

struct Die {
    var n = 0
    var count = 0
    
    mutating func roll() -> Int {
        let n = self.n + 1
        self.n = n % 100
        count = 1 + count
        return n
    }
}

struct Player {
    var score = 0
    var position = 0
    
    mutating func turn(die: inout Die) {
        let roll = die.roll() + die.roll() + die.roll()
        position = (position + roll) % 10
        score = score + 1 + position
    }
}

public func part1() -> Int {
    // positions are 1 less than puzzle input
    var p1 = Player(score: 0, position: 7)
    var p2 = Player(score: 0, position: 4)
    var die = Die()
    
    while true {
        p1.turn(die: &die)
        if p1.score >= 1000 {
            return die.count * p2.score
        }
        p2.turn(die: &die)
        if p2.score >= 1000 {
            return die.count * p1.score
        }
    }
}

