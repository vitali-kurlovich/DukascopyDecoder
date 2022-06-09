//
//  Created by Vitali Kurlovich on 16.12.20.
//

import DukascopyModel
import Foundation

struct Finstruments: Equatable {
    public let instruments: [String: Instrument]
    public let groups: [String: Group]
}

extension Finstruments {
    struct Group: Equatable {
        let id: String
        let title: String
        let parent: String?
        let instruments: [String]?
    }
}

extension Instrument {
    init(_ instrument: Finstruments.Instrument) {
        self.init(symbol: instrument.name,
                  meta: .init(instrument),

                  currency: .init(instrument),
                  history: .init(instrument),

                  pipValue: instrument.pipValue,
                  commoditiesPerContract: instrument.commoditiesPerContract)
    }
}

extension InstrumentCurrency {
    init(_ instrument: Finstruments.Instrument) {
        self.init(base: instrument.baseCurrency, quote: instrument.quoteCurrency)
    }
}

extension InstrumentMeta {
    init(_ instrument: Finstruments.Instrument) {
        self.init(title: instrument.title,
                  description: instrument.description,
                  tags: instrument.tags)
    }
}

extension InstrumentHistory {
    init(_ instrument: Finstruments.Instrument) {
        self.init(filename: instrument.filename ?? "",
                  beginTick: instrument.historyStartTick,
                  begin10sec: instrument.historyStart10sec,
                  beginMinute: instrument.historyStartMinute,
                  beginHour: instrument.historyStartHour)
    }
}

extension Finstruments {
    struct Instrument: Equatable {
        let title: String
        let special: Bool
        let name: String
        let description: String
        let filename: String?
        let pipValue: Double
        let baseCurrency: String
        let quoteCurrency: String
        let tags: [String]

        let historyStartTick: Date
        let historyStart10sec: Date
        let historyStartMinute: Date
        let historyStartHour: Date
        let historyStartDay: Date

        private let _commoditiesPerContract: String?

        var commoditiesPerContract: Int? {
            guard let commodities = _commoditiesPerContract else {
                return nil
            }
            return Int(commodities)
        }

        let unit: String?
    }
}

extension Finstruments.Instrument: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case special
        case name
        case description
        case filename = "historical_filename"
        case pipValue
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case tags = "tag_list"

        case historyStartTick = "history_start_tick"
        case historyStart10sec = "history_start_10sec"
        case historyStartMinute = "history_start_60sec"
        case historyStartHour = "history_start_60min"
        case historyStartDay = "history_start_day"

        case _commoditiesPerContract = "commodities_per_contract"
        case unit
    }
}

extension Finstruments.Group: Codable {}

extension Finstruments: Codable {}
