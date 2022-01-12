public extension String {
    func enumerating(withPattern pattern: String, stopAt stopHandler: @escaping (Match) -> Bool) throws {
        try SwifterRe.enumerating(in: self, matching: pattern, stopOn: stopHandler)
    }
}
