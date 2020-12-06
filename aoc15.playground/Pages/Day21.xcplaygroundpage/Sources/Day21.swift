import Foundation

struct Item {
    let cost: Int
    let damage: Int
    let armor: Int
}

func equipment() -> [Item] {
    let weapons = [
        Item(cost: 8, damage: 4, armor: 0),
        Item(cost: 10, damage: 5, armor: 0),
        Item(cost: 25, damage: 6, armor: 0),
        Item(cost: 40, damage: 7, armor: 0),
        Item(cost: 74, damage: 8, armor: 0),
    ]
    let armor = [
        Item(cost: 0, damage: 0, armor: 0),
        Item(cost: 13, damage: 0, armor: 1),
        Item(cost: 31, damage: 0, armor: 2),
        Item(cost: 53, damage: 0, armor: 3),
        Item(cost: 75, damage: 0, armor: 4),
        Item(cost: 102, damage: 0, armor: 5),
    ]
    let ring = [
        Item(cost: 0, damage: 0, armor: 0),
        Item(cost: 0, damage: 0, armor: 0),
        Item(cost: 25, damage: 1, armor: 0),
        Item(cost: 50, damage: 2, armor: 0),
        Item(cost: 100, damage: 3, armor: 0),
        Item(cost: 20, damage: 0, armor: 1),
        Item(cost: 40, damage: 0, armor: 2),
        Item(cost: 80, damage: 0, armor: 3),
    ]
    
    var result = [Item]()
    for rr in ring.combinations(taking: 2) {
        for w in weapons {
            for a in armor {
                result.append(
                    Item(
                    cost: rr[0].cost + rr[1].cost + w.cost + a.cost,
                    damage: rr[0].damage + rr[1].damage + w.damage + a.damage,
                    armor: rr[0].armor + rr[1].armor + w.armor + a.armor
                ))
            }
        }
    }
    return result
}

extension Item {
    func fightBoss() -> Bool {
        let boss = Item(cost: 0, damage: 8, armor: 1)
        var bossHP = 104
        var selfHP = 100
        while true {
            bossHP -= max(1, damage - boss.armor)
            guard bossHP > 0 else { return true }
            selfHP -= max(1, boss.damage - armor)
            guard selfHP > 0 else { return false }
        }
    }
}

public func part1() -> Int {
    for e in equipment().sorted{ $0.cost < $1.cost } {
        if e.fightBoss() {
            return e.cost
        }
    }
    return -1
}
