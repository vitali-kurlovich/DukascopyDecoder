import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(InstrumentsInfoDecoderTest.allTests),
        ]
    }
#endif
