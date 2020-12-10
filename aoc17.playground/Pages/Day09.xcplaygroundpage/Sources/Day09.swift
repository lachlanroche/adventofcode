import Foundation


public func part1() -> Int {
    var depth = 0
    var score = 0
    var skip = false
    var garbage = false
    for c in stringsFromFile(named: "input")[0] {
        if skip {
            skip = false

        } else if c == "!" {
            skip = true

        } else if garbage {
            if c == ">" {
                garbage = false
            }
            
        } else {
            if c == "<" {
                garbage = true
                
            } else if c == "{" {
                depth += 1
                score += depth

            } else if c == "}" {
                depth -= 1
            }
        }
    }
    
    return score
}


public func part2() -> Int {
    var depth = 0
    var score = 0
    var junk = 0
    var skip = false
    var garbage = false
    for c in stringsFromFile(named: "input")[0] {
        if skip {
            skip = false

        } else if c == "!" {
            skip = true

        } else if garbage {
            if c == ">" {
                garbage = false
            } else {
                junk += 1
            }
            
        } else {
            if c == "<" {
                garbage = true
                
            } else if c == "{" {
                depth += 1
                score += depth

            } else if c == "}" {
                depth -= 1
            }
        }
    }
    
    return junk
}
