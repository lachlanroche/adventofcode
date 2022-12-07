import Foundation

public func part1() -> Int {
    var filesystem: [String:Int] = [
        "/": 0
    ]
    var path = "/"
    
    for line in stringsFromFile() {
        guard line != "" else { break }
        if line == "$ cd /" {
            path = "/"
        } else if line == "$ cd .." {
            path = path.split(separator: "/").dropLast().joined(separator: "/")
            if !path.hasPrefix("/") {
                path = "/" + path
            }
            if !path.hasSuffix("/") {
                path = path + "/"
            }
        } else if line.hasPrefix("$ cd ") {
            let subdir = line.split(separator: " ").last!
            path = path + subdir + "/"
        } else if line == "$ ls" {
            // nothing
        } else {
            let parts = line.split(separator: " ")
            if parts[0] == "dir" {
                filesystem[path + parts[1] + "/"] = 0
            } else {
                filesystem[path + parts[1]] = Int(parts[0])!
            }
        }
    }
    
    var sizes = [String:Int]()
    for dir in filesystem.keys where dir.hasSuffix("/") {
        sizes[dir] = filesystem.filter({ $0.key.hasPrefix(dir) })
            .reduce(0, { $0 + $1.value })
    }
    
    return sizes.filter({ $0.value <= 100000 })
        .reduce(0, { $0 + $1.value })
}

public func part2() -> Int {
    var filesystem: [String:Int] = [
        "/": 0
    ]
    var path = "/"
    
    for line in stringsFromFile() {
        guard line != "" else { break }
        if line == "$ cd /" {
            path = "/"
        } else if line == "$ cd .." {
            path = path.split(separator: "/").dropLast().joined(separator: "/")
            if !path.hasPrefix("/") {
                path = "/" + path
            }
            if !path.hasSuffix("/") {
                path = path + "/"
            }
        } else if line.hasPrefix("$ cd ") {
            let subdir = line.split(separator: " ").last!
            path = path + subdir + "/"
        } else if line == "$ ls" {
            // nothing
        } else {
            let parts = line.split(separator: " ")
            if parts[0] == "dir" {
                filesystem[path + parts[1] + "/"] = 0
            } else {
                filesystem[path + parts[1]] = Int(parts[0])!
            }
        }
    }
    
    var sizes = [String:Int]()
    for dir in filesystem.keys where dir.hasSuffix("/") {
        sizes[dir] = filesystem.filter({ $0.key.hasPrefix(dir) })
            .reduce(0, { $0 + $1.value })
    }
    
    let total = sizes["/"]!
    let empty = 70000000 - total
    let need = 30000000 - empty
    
    for size in sizes.sorted(by: { $0.value < $1.value }) {
        if size.value >= need {
            return size.value
        }
    }
    
    return -1
}
