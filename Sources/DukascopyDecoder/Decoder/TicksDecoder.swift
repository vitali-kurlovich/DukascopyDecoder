//
//  DukascopyDecoder.swift
//  Chart
//
//  Created by Vitali Kurlovich on 3/12/20.
//  Copyright © 2020 Vitali Kurlovich. All rights reserved.
//

import Foundation

public
struct TicksDecoder {
    public
    struct Tick: Equatable {
        public let time: Int32
        public let askp: Int32
        public let bidp: Int32
        public let askv: Float32
        public let bidv: Float32

        public
        init(time: Int32, askp: Int32, bidp: Int32, askv: Float32, bidv: Float32) {
            self.time = time
            self.askp = askp
            self.bidp = bidp
            self.askv = askv
            self.bidv = bidv
        }
    }

    public
    init() {}
}

public
extension TicksDecoder {
    @available(OSX 10.11, *)
    func decode(with data: Data) throws -> [Tick] {
        if data.isEmpty {
            return []
        }

        guard let decompressed = data.decompress() else {
            throw DecoderError.decompressError
        }

        struct _Block {
            let time: Int32
            let askp: Int32
            let bidp: Int32
            let askv: UInt32
            let bidv: UInt32
        }

        return decompressed.withUnsafeBytes { (pointer) -> [Tick] in
            let memory = pointer.bindMemory(to: _Block.self)

            var blocks = [Tick]()
            blocks.reserveCapacity(memory.underestimatedCount / MemoryLayout<_Block>.size)

            for block in memory {
                let time = block.time.bigEndian
                let askp = block.askp.bigEndian
                let bidp = block.bidp.bigEndian

                let askv = block.askv.bigEndian
                let bidv = block.bidv.bigEndian

                let askV = Float32(bitPattern: askv)
                let bidV = Float32(bitPattern: bidv)

                blocks.append(.init(time: time, askp: askp, bidp: bidp, askv: askV, bidv: bidV))
            }

            return blocks
        }
    }
}
