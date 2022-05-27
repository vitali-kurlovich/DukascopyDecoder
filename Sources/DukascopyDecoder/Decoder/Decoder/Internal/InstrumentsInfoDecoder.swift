//
//  Created by Vitali Kurlovich on 26.12.20.
//

import Foundation

import DukascopyModel

struct InstrumentsInfoDecoder {
    func decode(with data: Data) throws -> Finstruments {
        let data = data.dropFirst("jsonp(".count).dropLast(")".count)

        return try InfoJSONDecoderFactory.decoder.decode(Finstruments.self, from: data)
    }
}

enum InfoJSONDecoderFactory {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let miliseconds = Int(dateStr) ?? 0

            let seconds = miliseconds / 1000

            let fraction = TimeInterval(miliseconds - (seconds * 1000)) / 1000

            return Date(timeIntervalSince1970: TimeInterval(seconds) + fraction)
        }

        return decoder
    }()
}
