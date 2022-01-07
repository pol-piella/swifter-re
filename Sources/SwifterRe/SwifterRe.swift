import Foundation

enum SwifterRe {
    static func findMatches(
        in text: String,
        matching pattern: String,
        options: NSRegularExpression.Options? = nil,
        shouldMatchGroups: Bool = true
    ) throws -> [Match] {
        let re = try NSRegularExpression(pattern: pattern, options: options ?? [])
        let range = NSRange(location: .zero, length: text.utf16.count)
        
        return re.matches(in: text, range: range).map { Self.adapt(result: $0, in: text) }
    }
    
    static func findFirstMatch(
        in text: String,
        matching pattern: String,
        options: NSRegularExpression.Options? = nil,
        shouldMatchGroups: Bool = true
    ) throws -> Match? {
        let re = try NSRegularExpression(pattern: pattern, options: options ?? [])
        let range = NSRange(location: .zero, length: text.utf8.count)
        guard let result = re.firstMatch(in: text, range: range) else { return nil }
        
        return Self.adapt(result: result, in: text)
    }
    
    static func enumerating(
        in text: String,
        matching pattern: String,
        stopOn: (Match) -> Bool,
        options: NSRegularExpression.Options? = nil,
        shouldMatchGroups: Bool = true
    ) throws {
        let re = try NSRegularExpression(pattern: pattern, options: options ?? [])
        let range = NSRange(location: .zero, length: text.utf8.count)
        
        re.enumerateMatches(in: text, range: range) { result, _, stop in
            guard let result = result else { return }
            let match = self.adapt(result: result, in: text)
            
            stop.pointee = ObjCBool(stopOn(match)) // Stop if condition is met
        }
    }
    
    // MARK: - Helpers
    
    private static func adapt(result: NSTextCheckingResult, in text: String, matchingGroups: Bool = true) -> Match {
        let groups = matchingGroups ? Self.matchGroups(result: result, text: text) : []
        let matchedString = String(text[Range(result.range, in: text)!])
        return Match(match: matchedString, groups: groups)
    }
    
    private static func matchGroups(result: NSTextCheckingResult, text: String) -> [Group] {
        (1..<result.numberOfRanges).map { index -> Group in
            let groupRange = result.range(at: index)
            let outputText = text[Range(groupRange, in: text)!]
            return Group(position: index - 1, value: String(outputText))
        }
    }
}
