import Foundation

enum State {
    case a
    case b
    case c
    case d
    case e
    case f
}

public func part1() -> Int {
    var mem = Dictionary<Int,Int>()
    var state = State.a
    var pos = 0

    for _ in 0..<12667664 {
        let value = mem[pos] ?? 0
        switch (state, value) {
        case (.a, 0):
            mem[pos] = 1
            pos += 1
            state = .b
            break
        case (.a, 1):
            mem[pos] = 0
            pos -= 1
            state = .c
            break
        case (.b, 0):
            mem[pos] = 1
            pos -= 1
            state = .a
            break
        case (.b, 1):
            mem[pos] = 1
            pos += 1
            state = .d
            break
        case (.c, 0):
            mem[pos] = 0
            pos -= 1
            state = .b
            break
        case (.c, 1):
            mem[pos] = 0
            pos -= 1
            state = .e
            break
        case (.d, 0):
            mem[pos] = 1
            pos += 1
            state = .a
            break
        case (.d, 1):
            mem[pos] = 0
            pos += 1
            state = .b
            break
        case (.e, 0):
            mem[pos] = 1
            pos -= 1
            state = .f
            break
        case (.e, 1):
            mem[pos] = 1
            pos -= 1
            state = .c
            break
        case (.f, 0):
            mem[pos] = 1
            pos += 1
            state = .d
            break
        case (.f, 1):
            mem[pos] = 1
            pos += 1
            state = .a
            break
        default:
            break
        }
    }
    
    return mem.values.reduce(into: 0) { (acc, n) in acc += n }
}
