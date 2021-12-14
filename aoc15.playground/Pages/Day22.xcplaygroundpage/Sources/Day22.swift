import Foundation

protocol Monster {
    var hp: Int { get set }
    var shield: Int { get }
}

extension Monster {
    var isDead: Bool { get { hp <= 0 }}
    mutating func injure(_ wound: Int) {
        hp = hp - max(1, (wound - shield))
    }
}

struct Boss: Monster {
    var hp = 55
    var damage = 8
    var shield = 0
}

enum Spell: Int {
    case missile = 53
    case drain = 73
    case shield = 113
    case poison = 173
    case recharge = 229
}

struct Player: Monster {
    var hp = 50
    var shield = 0
    var mana = 500
}

struct Battle {
    var t = 0
    var boss = Boss()
    var player = Player()
    var spellsCast = [Spell]()
    var manaSpent = 0
    var shield_t = 0
    var poison_t = 0
    var recharge_t = 0
}

var bestManaSpent = Int.max

func fight(_ battle: Battle) -> [Battle] {
    var war = battle
    
    if war.poison_t > 0 {
        war.boss.injure(3)
        war.poison_t = war.poison_t - 1
        if war.boss.isDead {
            if war.manaSpent < bestManaSpent {
                bestManaSpent = war.manaSpent
                return [war]
            } else {
                return []
            }
        }
    }
    if war.recharge_t > 0 {
        war.player.mana = war.player.mana + 101
        war.recharge_t = war.recharge_t - 1
    }
    if war.shield_t > 0 {
        war.shield_t = war.shield_t - 1
        if war.shield_t == 0 {
            war.player.shield = 0
        }
    }
    
    if 1 == war.t % 2 {
        war.player.injure(war.boss.damage)
        if war.player.isDead {
            return []
        } else {
            war.t = 1 + war.t
            return fight(war)
        }
        
    } else {
        var spells: Set<Spell> = []
        if war.player.mana >= Spell.missile.rawValue {
            spells.insert(.missile)
        }
        if war.player.mana >= Spell.drain.rawValue {
            spells.insert(.drain)
        }
        if war.poison_t == 0 && war.player.mana >= Spell.poison.rawValue {
            spells.insert(.poison)
        }
        if war.recharge_t == 0 && war.player.mana >= Spell.recharge.rawValue {
            spells.insert(.recharge)
        }
        if war.shield_t == 0 && war.player.mana >= Spell.shield.rawValue {
            spells.insert(.shield)
        }

        if spells.isEmpty {
            war.t = 1 + war.t
            return fight(war)
        }
        
        var wars = [Battle]()
        for s in spells {
            var w = war
            w.player.mana = w.player.mana - s.rawValue
            w.manaSpent = w.manaSpent + s.rawValue
            w.spellsCast.append(s)
            switch s {
            case .missile:
                w.boss.injure(4)
                break
            case .drain:
                w.boss.injure(2)
                w.player.hp = 2 + war.player.hp
                break
            case .poison:
                w.poison_t = 6
                break
            case .recharge:
                w.recharge_t = 5
                break
            case .shield:
                w.player.shield = 7
                w.shield_t = 6
                break
            }
            
            if w.manaSpent >= bestManaSpent {
                continue
            }
            if w.boss.isDead {
                if w.manaSpent < bestManaSpent {
                    bestManaSpent = w.manaSpent
                    wars.append(w)
                }
            } else {
                w.t = 1 + w.t
                wars = wars + fight(w)
            }
        }
        return wars
    }
}

public func part1() -> Int {
    bestManaSpent = Int.max
    let result = fight(Battle()).sorted(by: { $0.manaSpent < $1.manaSpent }).first!
    print(result.spellsCast)
    return result.manaSpent
}

