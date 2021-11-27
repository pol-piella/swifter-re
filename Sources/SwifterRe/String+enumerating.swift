public extension String {
    func enumerating(withPattern pattern: String, stopAt stopHandler: (Match) -> Bool) throws {
        try SwifterRe.enumerating(in: self, matching: pattern, stopOn: stopHandler)
    }
}
