//
//  File.swift
//
//
//  Created by Vitali Kurlovich on 27.12.20.
//

@testable import DukascopyDecoder
import XCTest

private let moc = MocBi5()
private let decoder = TicksDecoder()

final class TicksDecoderTest: XCTestCase {
    func testTicksDecoding() {
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

    func testTicksDecoding_1() {
        let begin = formatter.date(from: "02-01-2020 01:00")!
        let end = formatter.date(from: "02-01-2020 02:00")!
        let range = begin ..< end

        XCTAssertNoThrow { try decoder.decode(in: range, with: moc.USDTHB) }

        let container = try! decoder.decode(in: range, with: moc.USDTHB)

        let dstBegin = accuracyFormatter.date(from: "02-01-2020 01:00:00.138")!
        let dstEnd = accuracyFormatter.date(from: "02-01-2020 01:59:53.390")!

        XCTAssertEqualDate(container.ticksTimeRange!, dstBegin ..< dstEnd)
    }

    
}

private let utc = TimeZone(identifier: "UTC")!

private let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = utc
    return calendar
}()

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.timeZone = utc
    formatter.dateFormat = "dd-MM-yyyy HH:mm"
    return formatter
}()

private let accuracyFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.timeZone = utc
    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSSS"
    return formatter
}()
