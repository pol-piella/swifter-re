import XCTest
@testable import SwifterRe

final class SwifterReTests: XCTestCase {
    private let testString = """
    I love cats and dogs
    I love hats and cogs
    """
    
    func testThatAStringMatchCanHaveNoGroups() throws {
        let re = #"I love"#
        let expectedMatches: [Match] = [Match(match: "I love", groups: [])]

        expect(thatResultingMatches: [try SwifterRe.findMatches(in: testString, matching: re).first!], matchExpectedMatches: expectedMatches)
    }
    
    func testThatAStringPatternCanReturnMultipleMatches() throws {
        let re = #"I love"#
        let expectedMatches: [Match] = [Match(match: "I love", groups: []), Match(match: "I love", groups: []),]
        
        expect(thatResultingMatches: try SwifterRe.findMatches(in: testString, matching: re), matchExpectedMatches: expectedMatches)
    }
    
    func testThatAMatchCanContainAGroup() throws {
        let re = #"I love (\w+\b)"#
        let expectedMatches: [Match] = [
            Match(match: "I love cats", groups: [Group(position: .zero, value: "cats")]),
            Match(match: "I love hats", groups: [Group(position: .zero, value: "hats")]),
        ]
        
        expect(thatResultingMatches: try SwifterRe.findMatches(in: testString, matching: re), matchExpectedMatches: expectedMatches)
    }
    
    func testThatMultipleGroupsInAMatchAreOrderedByAppearance() throws {
        let re = #"I love (.ats).*(.ogs)"#
        let expectedMatches: [Match] = [
            Match(match: "I love cats and dogs", groups: [Group(position: .zero, value: "cats"), Group(position: 1, value: "dogs")]),
            Match(match: "I love hats and cogs", groups: [Group(position: .zero, value: "hats"), Group(position: 1, value: "cogs")]),
        ]
                
        expect(thatResultingMatches: try SwifterRe.findMatches(in: testString, matching: re), matchExpectedMatches: expectedMatches)
    }
    
    func testThatEnumerateMatchesStopsWhenConditionIsMet() throws {
        let re = #"I love (.ats).*(.ogs)"#
        let stopPoint = Match(match: "I love cats and dogs", groups: [Group(position: .zero, value: "cats"), Group(position: 1, value: "dogs")])
        var capturedMatches = [Match]()
        
        try SwifterRe.enumerating(in: testString, matching: re) { match in
            capturedMatches.append(match)
            return match.groups == stopPoint.groups
        }
        
        expect(thatResultingMatches: [stopPoint], matchExpectedMatches: capturedMatches)
    }
    
    // MARK: - Helpers
    
    private func expect(thatResultingMatches matches: [Match], matchExpectedMatches expectedMatches: [Match]) {
        XCTAssertEqual(matches, matches)
    }
}
