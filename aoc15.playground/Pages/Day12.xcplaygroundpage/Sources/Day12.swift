import Foundation

public func part1() -> Int {
    let s = stringsFromFile(named: "input")[0]
    let nsstr = s as NSString
    let regex = try! NSRegularExpression(pattern: "-?[0-9]+")
    var total = 0

    regex.enumerateMatches(in: s, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: nsstr.length)) {
      (result : NSTextCheckingResult?, _, _) in
      if let r = result {
        let result = nsstr.substring(with: r.range) as String
        total += Int(result)!
      }
    }

    return total
}
