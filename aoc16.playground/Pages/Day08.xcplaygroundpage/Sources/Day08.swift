import Foundation

public func part1() -> Int {
    var screen: Array<Array<Character>> = .init(repeating: Array(repeating: ".", count: 50), count: 6)
    for line in stringsFromFile() where line != "" {
        if line.hasPrefix("rect ") {
            let parts = line.dropFirst(5).split(separator: "x")
            for x in 0..<Int(parts[0])! where x < 50 {
                for y in 0..<Int(parts[1])! where y < 6 {
                    screen[y][x] = "#"
                }
            }
        } else if line.hasPrefix("rotate row") {
            let parts = line.dropFirst(13).components(separatedBy: " by ")
            let y = Int(parts[0])!
            let dx = Int(parts[1])!
            let row = screen[y]
            for x in 0..<50 {
                screen[y][x] = row[(x - dx + 50) % 50]
            }
        } else if line.hasPrefix("rotate col") {
            let parts = line.dropFirst(16).components(separatedBy: " by ")
            let x = Int(parts[0])!
            let dy = Int(parts[1])!
            var col = Array<Character>()
            for y in 0..<6 {
                col.append(screen[y][x])
            }
            for y in 0..<6 {
                screen[y][x] = col[(y - dy + 6) % 6]
            }
        }
    }
    
    return screen.map({ $0.reduce(0, { $1 == "#" ? 1 + $0 : $0 }) })
        .reduce(0, +)
}

public func part2() -> Void {
    var screen: Array<Array<Character>> = .init(repeating: Array(repeating: ".", count: 50), count: 6)
    for line in stringsFromFile() where line != "" {
        if line.hasPrefix("rect ") {
            let parts = line.dropFirst(5).split(separator: "x")
            for x in 0..<Int(parts[0])! where x < 50 {
                for y in 0..<Int(parts[1])! where y < 6 {
                    screen[y][x] = "#"
                }
            }
        } else if line.hasPrefix("rotate row") {
            let parts = line.dropFirst(13).components(separatedBy: " by ")
            let y = Int(parts[0])!
            let dx = Int(parts[1])!
            let row = screen[y]
            for x in 0..<50 {
                screen[y][x] = row[(x - dx + 50) % 50]
            }
        } else if line.hasPrefix("rotate col") {
            let parts = line.dropFirst(16).components(separatedBy: " by ")
            let x = Int(parts[0])!
            let dy = Int(parts[1])!
            var col = Array<Character>()
            for y in 0..<6 {
                col.append(screen[y][x])
            }
            for y in 0..<6 {
                screen[y][x] = col[(y - dy + 6) % 6]
            }
        }
    }
    
    var show = Array<Character>()
    for y in 0..<6 {
        for x in 0..<50 {
            show.append(screen[y][x])
        }
        show.append("\n")
    }
    print(String(show))
    print("\n")
}
