import Foundation

struct Ingredient {
    let capacity: Int
    let durability: Int
    let flavor: Int
    let texture: Int
    let calories: Int
}


func cookieScoreFrom(_ ingredients: [(Int, Ingredient)], withCalories: Int? = nil) -> Int {
    let capacity = ingredients.map{ $0 * $1.capacity }.reduce(0, +)
    let durability = ingredients.map{ $0 * $1.durability }.reduce(0, +)
    let flavor = ingredients.map{ $0 * $1.flavor }.reduce(0, +)
    let texture = ingredients.map{ $0 * $1.texture }.reduce(0, +)
    let calories = ingredients.map{ $0 * $1.calories }.reduce(0, +)

    if let withCalories = withCalories {
        guard calories == withCalories else { return 0 }
    }
    
    return max(0, capacity) * max(0, durability) * max(0, flavor) * max(0, texture)
}

func bestCookieScore(with calories: Int? = nil) -> Int {
    var best = 0
    for spr in 0...100 {
        for pea in 0...(100-spr) {
            for fro in 0...(100-spr-pea) {
                let sug = 100 - spr - pea - fro
                let score = cookieScoreFrom([
                    (spr, Ingredient(capacity: 5, durability: -1, flavor: 0, texture: 0, calories: 5)),
                    (pea, Ingredient(capacity: -1, durability: 3, flavor: 0, texture: 0, calories: 1)),
                    (fro, Ingredient(capacity: 0, durability: -1, flavor: 4, texture: 0, calories: 6)),
                    (sug, Ingredient(capacity: -1, durability: 0, flavor: 0, texture: 2, calories: 8)),
                ], withCalories: calories)
                best = max(score, best)
            }
        }
    }
    
    return best
}

public func part1() -> Int {
    return bestCookieScore()
}

public func part2() -> Int {
    return bestCookieScore(with: 500)
}
