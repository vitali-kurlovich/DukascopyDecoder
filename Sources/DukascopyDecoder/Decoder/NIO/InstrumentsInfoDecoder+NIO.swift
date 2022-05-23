//
//  Created by Vitali Kurlovich on 23.05.22.
//

import Foundation

import DukascopyModel
import NIO

public
extension InstrumentsInfoDecoder {
    func decode(with buffer: ByteBuffer) throws -> Finstruments {
        var buffer = buffer
        buffer.moveReaderIndex(to: "jsonp(".count)

        return try buffer.readJSONDecodable(Finstruments.self, decoder: InfoJSONDecoderFactory.decoder, length: buffer.readableBytes - ")".count)!
    }
}
