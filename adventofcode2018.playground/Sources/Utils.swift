import Foundation

public func numbersFromFile(named: String) -> [Int]
{
    guard let path = Bundle.main.path(forResource: named, ofType: "txt") else { return [] }
    guard let data = FileManager.default.contents(atPath: path) else { return [] }
    guard let content = String(data:data, encoding:String.Encoding.utf8) else { return [] }

    return content.components(separatedBy: CharacterSet.newlines)
        .compactMap(Int.init)
}

public func numbersFromString(_ str: String) -> [Int]
{
    return str.components(separatedBy: CharacterSet.whitespacesAndNewlines.union(CharacterSet.init(charactersIn: ",")))
        .compactMap(Int.init)
}
