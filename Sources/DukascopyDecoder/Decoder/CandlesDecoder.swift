//
//  Created by Vitali Kurlovich on 4/19/20.
//

import DukascopyModel
import Foundation

public
struct CandlesDecoder {
    public typealias Candle = DukascopyModel.Candle

    public
    init() {}
}

public
extension CandlesDecoder {
    func decode(with data: Data) throws -> [Candle] {
        if data.isEmpty {
            return []
        }

        guard let decompressed = try? data.decompress() else {
            throw DecoderError.decompressError
        }

        struct _Block {
            let time: Int32
            let open: Int32
            let close: Int32
            let low: Int32
            let high: Int32
            let volume: UInt32
        }

        let candles = decompressed.withUnsafeBytes { pointer -> [Candle] in
            let memory = pointer.bindMemory(to: _Block.self)

            var candles = [Candle]()
            candles.reserveCapacity(memory.underestimatedCount / MemoryLayout<_Block>.size)

            for block in memory {
                let time = block.time.bigEndian
                let open = block.open.bigEndian
                let close = block.close.bigEndian
                let low = block.low.bigEndian
                let high = block.high.bigEndian
                let volume = Float32(bitPattern: block.volume.bigEndian)

                let price = Candle.Price(open: open, close: close, low: low, high: high)

                candles.append(.init(time: time, price: price, volume: volume))
            }

            return candles
        }

        return candles
    }
}
