import Foundation

public func stringsFromFile(named: String = "input") -> [String]
{
    guard let path = Bundle.main.path(forResource: named, ofType: "txt") else { return [] }
    guard let data = FileManager.default.contents(atPath: path) else { return [] }
    guard let content = String(data:data, encoding:String.Encoding.utf8) else { return [] }
    
    return content.components(separatedBy: CharacterSet.newlines)
}

public func numbersFromFile(named: String) -> [Int]
{
    return stringsFromFile(named: named)
        .compactMap(Int.init)
}

public func stringsFromString(_ str: String) -> [String]
{
    return str.components(separatedBy: CharacterSet.whitespacesAndNewlines.union(CharacterSet.init(charactersIn: ",")))
}

public func numbersFromString(_ str: String) -> [Int]
{
    return stringsFromString(str)
        .compactMap(Int.init)
}
