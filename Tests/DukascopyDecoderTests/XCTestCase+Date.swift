//
//  Created by Vitali Kurlovich on 4/15/20.
//

import Foundation
import XCTest

public func XCTAssertEqualDate(_ expression1: @autoclosure () throws -> Date, _ expression2: @autoclosure () throws -> Date, accuracy: TimeInterval = 0.001, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(try expression1().timeIntervalSince1970, try expression2().timeIntervalSince1970, accuracy: accuracy, message(), file: file, line: line)
}

public func XCTAssertEqualDate(_ expression1: @autoclosure () throws -> Range<Date>, _ expression2: @autoclosure () throws -> Range<Date>, accuracy: TimeInterval = 0.001, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(try expression1().lowerBound.timeIntervalSince1970, try expression2().lowerBound.timeIntervalSince1970, accuracy: accuracy, message(), file: file, line: line)

    XCTAssertEqual(try expression1().upperBound.timeIntervalSince1970, try expression2().upperBound.timeIntervalSince1970, accuracy: accuracy, message(), file: file, line: line)
}
