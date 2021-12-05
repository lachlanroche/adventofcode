import Foundation

public func stringFromFile(named: String = "input") -> String
{
    guard let path = Bundle.main.path(forResource: named, ofType: "txt") else { return "" }
    guard let data = FileManager.default.contents(atPath: path) else { return "" }
    guard let content = String(data:data, encoding:String.Encoding.utf8) else { return "" }
    
    return content
}

public func stringsFromFile(named: String = "input") -> [String]
{
    return stringFromFile(named: named).components(separatedBy: CharacterSet.newlines)
}

public func numbersFromFile(named: String) -> [Int]
{
    return stringsFromFile(named: named)
        .compactMap(Int.init)
}

public func stringsFromString(_ str: String, sep: String = ",") -> [String]
{
    return str.components(separatedBy: CharacterSet.whitespacesAndNewlines.union(CharacterSet.init(charactersIn: sep)))
}

public func numbersFromString(_ str: String, sep: String = ",") -> [Int]
{
    return stringsFromString(str, sep: sep)
        .compactMap(Int.init)
}

public extension String {
    public subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound, range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    public subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}
