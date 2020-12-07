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

func sum(_ obj: AnyObject) -> Int {
    if let num = obj as? Int {
        return num
    }
    if let num = obj as? String {
        return 0
    }
    if let arr = obj as? NSArray {
        var arr_total = 0
        for arr_i in 0..<arr.count {
            arr_total += sum(arr[arr_i] as! AnyObject)
        }
        return arr_total
    }
    if let dict = obj as? NSDictionary {
        if dict.allValues.contains{ ($0 as? String) == "red" } { return 0 }
        var dict_total = 0
        for v in dict.allValues {
            dict_total += sum(v as! AnyObject)
        }
        return dict_total
    }
    
    return 0
}

public func part2() -> Int {
    let s = stringsFromFile(named: "input")[0]
    let data = s.data(using: .ascii)!
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! AnyObject
    return sum(json)
}
