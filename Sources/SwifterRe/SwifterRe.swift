import Foundation

enum SwifterRe {
    static func findMatches(
        in text: String,
        matching pattern: String,
        options: NSRegularExpression.Options? = nil,
        shouldMatchGroups: Bool = true
    ) throws -> [Match] {
        let re = try NSRegularExpression(pattern: pattern, options: options ?? [])
        let range = NSRange(location: .zero, length: text.utf8.count)
        
        return re.matches(in: text, range: range).map { result in
            let groups = shouldMatchGroups ? Self.matchGroups(result: result, text: text) : []
            let matchedString = String(text[Range(result.range, in: text)!])
            return Match(match: matchedString, groups: groups)
        }
    }
    
    private static func matchGroups(result: NSTextCheckingResult, text: String) -> [Group] {
        (1..<result.numberOfRanges).map { index -> Group in
            let groupRange = result.range(at: index)
            let outputText = text[Range(groupRange, in: text)!]
            return Group(position: index - 1, value: String(outputText))
        }
    }
}
