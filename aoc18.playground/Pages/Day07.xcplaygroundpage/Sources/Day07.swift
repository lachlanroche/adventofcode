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

struct Worker {
    let task: String
    let finish: Int
}

public func part2() -> Int {
    var ready = Set<String>()
    var waiting = Dictionary<String,Set<String>>()
    
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
    
    func nextTask() -> String? {
        if ready.isEmpty {
            return nil
        }
        
        let ca = Array(ready).sorted()
        let c = ca[0]
        ready.remove(c)
        
        return c
    }

    func completeTask(_ t: String) {
        for k in waiting.keys {
            waiting[k]?.remove(t)
            if waiting[k]!.isEmpty {
                ready.insert(k)
                waiting.removeValue(forKey: k)
            }
        }
    }
    
    func finishTime(_ s: String) -> Int {
        let t = s.map { Int($0.asciiValue!) }[0]
        return t - 4
    }

    var workers = Array<Worker>()
    
    var t = 0
    while true {
        for i in 0..<max(0, 5 - workers.count) {
            if let nt = nextTask() {
                let finish = t + finishTime(nt)
                workers.append(Worker(task: nt, finish: finish))
            }
        }
        
        if workers.isEmpty {
            return t
        }
        
        workers.sort(by: { $0.finish < $1.finish })
        t = workers[0].finish
        for w in workers.filter { $0.finish == workers[0].finish } {
            completeTask(w.task)
        }
        workers = workers.filter { $0.finish > t }
    }
    
    return t
}
