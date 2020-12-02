import Foundation

public func stringsFromFile(named name: String = "input") -> [String]
{
    guard let path = Bundle.main.path(forResource: name, ofType: "txt") else { return [] }
    guard let data = FileManager.default.contents(atPath: path) else { return [] }
    guard let content = String(data:data, encoding:String.Encoding.utf8) else { return [] }
    
    return content.components(separatedBy: CharacterSet.newlines)
}

public func firstLineFromFile(named name: String = "input") -> String
{
    return stringsFromFile(named: name)[0]
}
