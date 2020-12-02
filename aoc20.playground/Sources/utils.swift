import Foundation

public func stringsFromFile(named: String = "input") -> [String]
{
    guard let path = Bundle.main.path(forResource: named, ofType: "txt") else { return [] }
    guard let data = FileManager.default.contents(atPath: path) else { return [] }
    guard let content = String(data:data, encoding:String.Encoding.utf8) else { return [] }
    
    return content.components(separatedBy: CharacterSet.newlines)
}
