//
//  Created by Vitali Kurlovich on 26.12.20.
//

import Foundation

@testable import DukascopyDecoder
import NIO
import XCTest

final class InstrumentsInfoDecoderTest: XCTestCase {
    func testInstrumentsInfoDecoder() throws {
        let decoder = InstrumentsInfoDecoder()

        let finstruments = try decoder.decode(with: MocInstrumentsInfo.jsonData)

        let _jcius = finstruments.instruments["JCI.US/USD"]

        XCTAssertNotNil(_jcius)
        let jcius = _jcius!

        XCTAssertEqual(jcius.title, "JCI.US/USD")
        XCTAssertFalse(jcius.special)
        XCTAssertEqual(jcius.name, "JCI.US/USD")
        XCTAssertEqual(jcius.description, "JOHNSON CONTROLS INC")
        XCTAssertEqual(jcius.filename, "JCIUSUSD")
        XCTAssertEqual(jcius.pipValue, 0.01)
        XCTAssertEqual(jcius.baseCurrency, "JCI.US")
        XCTAssertEqual(jcius.quoteCurrency, "USD")
        XCTAssertEqual(jcius.commoditiesPerContract, 1)
        XCTAssertEqual(jcius.tags, ["CFD_INSTRUMENTS"])

        XCTAssertEqual(jcius.historyStartTick, accuracyFormatter.date(from: "02-11-2017 14:54:23.594")!)
        XCTAssertEqual(jcius.historyStart10sec, accuracyFormatter.date(from: "02-11-2017 14:54:20.000")!)
        XCTAssertEqual(jcius.historyStartMinute, accuracyFormatter.date(from: "02-11-2017 14:54:00.000")!)
        XCTAssertEqual(jcius.historyStartHour, accuracyFormatter.date(from: "02-11-2017 14:00:00.000")!)
        XCTAssertEqual(jcius.historyStartDay, accuracyFormatter.date(from: "02-11-2017 00:00:00.000")!)
        XCTAssertNil(jcius.unit)

        let _group = finstruments.groups["Hong Kong"]

        XCTAssertNotNil(_group)

        let group = _group!

        XCTAssertEqual(group.id, "Hong Kong")
        XCTAssertEqual(group.title, "Hong Kong")
        XCTAssertEqual(group.parent, "STCK_CFD")
        XCTAssertEqual(group.instruments,
                       [
                           "E_0883-HKG",
                           "E_0939-HKG",
                           "E_0941-HKG",
                           "E_1398-HKG",
                           "E_3988-HKG",
                       ])

        let buffer = ByteBuffer(data: MocInstrumentsInfo.jsonData)

        let nioFinstruments = try decoder.decode(with: buffer)

        XCTAssertEqual(finstruments, nioFinstruments)

        let groupDecoder = InstrumentsGroupsDecoder()

        let groups = try groupDecoder.decode(with: MocInstrumentsInfo.jsonData)

        let nioGroups = try groupDecoder.decode(with: buffer)

        XCTAssertEqual(groups, nioGroups)
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
