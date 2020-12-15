//
//  CandlesDecoder.swift
//  Dukascopy
//
//  Created by Vitali Kurlovich on 4/19/20.
//

import Foundation

public
struct CandlesDecoder {
    public
    struct Candle: Equatable {
        public
        struct Price: Equatable {
            public let open: Int32
            public let close: Int32
            public let low: Int32
            public let high: Int32
        }

        public let time: Int32
        public let price: Price
        public let volume: Float32
    }
    
    public
    init() {
    }
}

public
extension CandlesDecoder {
    @available(OSX 10.11, *)
    func decode(with data: Data) throws -> [Candle] {
        if data.isEmpty {
            return []
        }

        guard let decompressed = data.decompress() else {
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

        let candles = decompressed.withUnsafeBytes { (pointer) -> [Candle] in
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
