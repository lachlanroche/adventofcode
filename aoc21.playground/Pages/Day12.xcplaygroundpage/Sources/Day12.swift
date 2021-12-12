import Foundation

func inputData() -> Dictionary<String,Set<String>> {
    var result = Dictionary<String,Set<String>>()
    for s in stringsFromFile() {
        guard s.contains("-") else { continue }
        let parts = s.components(separatedBy: "-")
        let a = parts[0]
        let b = parts[1]
        result[a] = (result[a] ?? [])
        result[b] = (result[b] ?? [])
        result[a]!.insert(b)
        result[b]!.insert(a)
    }
    return result
}

public func part1() -> Int {

    func search(_ pos: String, visited: Set<String>) -> Int {
        if pos == "end" {
            return 1
        }
        
        var count = 0
        for next in edges[pos]! {
            if next == next.lowercased() && next != "end" {
                if !visited.contains(next) {
                    count = count + search(next, visited: visited.union([next]))
                }
            } else {
                count = count + search(next, visited: visited)
            }
        }
        return count
    }
    
    let edges = inputData()
    return search("start", visited: ["start"])
}

