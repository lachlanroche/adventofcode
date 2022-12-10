import Foundation
import CryptoKit

func md5(_ string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

public func part1() -> String {
    let door = "cxdnnyjw"
    var result = [Character]()
    var i = 0
    while true {
        guard result.count != 8 else { break }
        
        let hash = md5("\(door)\(i)")
        if hash.hasPrefix("00000") {
            result.append(hash[5])
        }
        
        i += 1
    }
    
    return String(result)
}

public func part2() -> String {
    let door = "cxdnnyjw"
    var result = Array<Character?>(repeating: nil, count: 8)
    var i = 0
    while true {
        guard result.contains(nil) else { break }
        
        let hash = md5("\(door)\(i)")
        if
            hash.hasPrefix("00000"),
            let idx = hash[5].wholeNumberValue,
            0...7 ~= idx,
            result[idx] == nil
        {
            result[idx] = hash[6]
        }
        i += 1
    }
    
    return String(result.compactMap({ $0 }))
}
