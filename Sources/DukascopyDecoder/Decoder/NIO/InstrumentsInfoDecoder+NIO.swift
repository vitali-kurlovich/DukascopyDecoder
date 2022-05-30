//
//  Created by Vitali Kurlovich on 23.05.22.
//

import Foundation

import DukascopyModel
import NIO

extension InstrumentsInfoDecoder {
    func decode(with buffer: ByteBuffer) throws -> Finstruments {
        var buffer = buffer
       
       _ = buffer.readString(length: "jsonp(".count, encoding: .utf8)

        return try buffer.readJSONDecodable(Finstruments.self, decoder: InfoJSONDecoderFactory.decoder, length: buffer.readableBytes - ")".count)!
    }
}
