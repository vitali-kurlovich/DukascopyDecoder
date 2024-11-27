//
//  Created by Vitali Kurlovich on 3/12/20.
//  Copyright © 2020 Vitali Kurlovich. All rights reserved.
//

import DukascopyModel
import Foundation
import SWCompression

public
extension TicksDecoder {
    func decode(in timeRange: Range<Date>, with data: Data) throws(DecoderError) -> TicksContainer {
        let ticks = try decode(with: data)

        return .init(timeRange: timeRange, ticks: ticks)
    }
}

public
extension TicksDecoder {
    func decode(with data: Data) throws(DecoderError) -> [Tick] {
        if data.isEmpty {
            return []
        }
        do {
            let decompressed = try data.decompress()

            struct _Block {
                let time: Int32
                let askp: Int32
                let bidp: Int32
                let askv: UInt32
                let bidv: UInt32
            }

            return decompressed.withUnsafeBytes { pointer -> [Tick] in
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

        } catch {
            throw DecoderError.decompressError
        }
    }
}
