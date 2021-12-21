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

struct Game: Hashable {
    var pos1 = 0
    var pos2 = 0
    var score1 = 0
    var score2 = 0
    
    mutating func nextPlayer() {
        var tmp = pos1
        pos1 = pos2
        pos2 = tmp
        tmp = score1
        score1 = score2
        score2 = tmp
    }
}

public func part2() -> Int {
 
    var cache = Dictionary<Game,(Int,Int)>()
    func wins(game: Game) -> (Int, Int) {
        if game.score1 >= 21 {
            return (1, 0)
        }
        if game.score2 >= 21 {
            return (0, 1)
        }
        if let cached = cache[game] {
            return cached
        }
        
        var result = (0, 0)
        for d1 in 1...3 {
            for d2 in 1...3 {
                for d3 in 1...3 {
                    var next = game
                    next.pos1 = (game.pos1 + d1 + d2 + d3) % 10
                    next.score1 = game.score1 + next.pos1 + 1
                    next.nextPlayer()
                    let (w1, w2) = wins(game: next)
                    
                    result.0 = result.0 + w2
                    result.1 = result.1 + w1
                }
            }
        }
        cache[game] = result
        return result
    }
    
    let result = wins(game: Game(pos1: 7, pos2: 4, score1: 0, score2: 0))
    return max(result.0, result.1)
}
