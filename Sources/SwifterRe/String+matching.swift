public extension String {
    func matching(pattern: String) -> [Match] {
        (try? SwifterRe.findMatches(in: self, matching: pattern)) ?? []
    }
}
