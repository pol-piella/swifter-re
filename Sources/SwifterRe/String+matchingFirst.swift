public extension String {
    func matchingFirst(pattern: String) -> Match? {
        try? SwifterRe.findFirstMatch(in: self, matching: pattern)
    }
}
