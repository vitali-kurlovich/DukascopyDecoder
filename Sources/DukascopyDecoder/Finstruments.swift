//
//  Created by Vitali Kurlovich on 16.12.20.
//

import Foundation

public
struct Finstruments: Equatable {
    public let instruments: [String: Instrument]
    public let groups: [String: Group]
}

public
extension Finstruments {
    struct Group: Equatable {
        public let id: String
        public let title: String
        public let parent: String?
        public let instruments: [String]?
    }
}

public
extension Finstruments {
    struct Instrument: Equatable {
        public let title: String
        public let special: Bool
        public let name: String
        public let description: String
        public let filename: String?
        public let pipValue: Double
        public let baseCurrency: String
        public let quoteCurrency: String
        public let tags: [String]

        public let historyStartTick: Date
        public let historyStart10sec: Date
        public let historyStartMinute: Date
        public let historyStartHour: Date
        public let historyStartDay: Date

        private let _commoditiesPerContract: String?

        public var commoditiesPerContract: Int? {
            guard let commodities = _commoditiesPerContract else {
                return nil
            }
            return Int(commodities)
        }

        public let unit: String?
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
