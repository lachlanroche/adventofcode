import Foundation


public func part1() -> String {
    var ready = Set<String>()
    var waiting = Dictionary<String,Set<String>>()
    var result = ""
    
    for s in stringsFromFile() {
        guard s != "" else { continue }
        let a = s[5..<6]
        let b = s[36..<37]

        var waitfor = (waiting[b] ?? Set())
        waitfor.insert(a)
        waiting[b] = waitfor
        
        if waiting[a] == nil {
            waiting[a] = Set()
        }
    }
    
    for k in waiting.keys {
        if waiting[k]!.isEmpty {
            ready.insert(k)
            waiting.removeValue(forKey: k)
        }
    }
    
    while true {
        if ready.isEmpty {
            return result
        }
        
        let ca = Array(ready).sorted()
        let c = ca[0]
        result.append(c)
        ready.remove(c)
        
        for k in waiting.keys {
            waiting[k]?.remove(c)
            if waiting[k]!.isEmpty {
                ready.insert(k)
                waiting.removeValue(forKey: k)
            }
        }
    }
}
