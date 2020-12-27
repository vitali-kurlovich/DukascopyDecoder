//
//  File.swift
//
//
//  Created by Vitali Kurlovich on 27.12.20.
//

@testable import DukascopyDecoder
import XCTest

final class TicksDecoderTest: XCTestCase {
    func testTicksDecoding() {
        let moc = MocBi5()

        let decoder = TicksDecoder()

        XCTAssertNoThrow { try decoder.decode(with: moc.USDTHB) }

        let ticks = try! decoder.decode(with: moc.USDTHB)

        XCTAssertEqual(ticks.count, 1096)

        // 02.01.2020 04:00:00.138 GMT+0300,30.1296,30.113400000000002,1,1
        let firstTick = ticks.first!
        XCTAssertEqual(firstTick.time, 138)
        XCTAssertEqual(firstTick.askp, 301_296)
        XCTAssertEqual(firstTick.bidp, 301_134)
        XCTAssertEqual(firstTick.askv, 1)
        XCTAssertEqual(firstTick.bidv, 1)

        // 02.01.2020 04:59:53.390 GMT+0300,30.1186,30.107400000000002,1.1,1.1
        let lastTick = ticks.last!
        XCTAssertEqual(lastTick.time, (59 * 60 + 53) * 1000 + 390)
        XCTAssertEqual(lastTick.askp, 301_186)
        XCTAssertEqual(lastTick.bidp, 301_074)
        XCTAssertEqual(lastTick.askv, 1.1)
        XCTAssertEqual(lastTick.bidv, 1.1)
    }

    static var allTests = [
        ("testTicksDecoding", testTicksDecoding),
    ]
}
