//
//  Created by Vitali Kurlovich on 23.05.22.
//

import DukascopyModel
import Foundation
import NIO

public
struct TicksDecoder {
    public typealias Tick = DukascopyModel.Tick

    public
    init() {}
}

public
extension TicksDecoder {
    func decode(in timeRange: Range<Date>, with buffer: ByteBuffer) throws -> TicksContainer {
        let ticks = try decode(with: buffer)

        return .init(timeRange: timeRange, ticks: ticks)
    }
}

public
extension TicksDecoder {
    func decode(with buffer: ByteBuffer) throws -> [Tick] {
        var ticks: [Tick] = []

        if buffer.readableBytes == 0 {
            return ticks
        }

        guard var dataBuffer = try buffer.decompress() else {
            return ticks
        }

        let blockSize = 3 * MemoryLayout<Int32>.size + 2 * MemoryLayout<UInt32>.size

        let underestimatedCount = dataBuffer.readableBytes / blockSize
        ticks.reserveCapacity(underestimatedCount)

        while dataBuffer.readableBytes >= blockSize {
            let block: (Int32, Int32, Int32, UInt32, UInt32) = dataBuffer.readMultipleIntegers(endianness: .big)!

            let time = block.0
            let askp = block.1
            let bidp = block.2

            let askv = block.3
            let bidv = block.4

            let askV = Float32(bitPattern: askv)
            let bidV = Float32(bitPattern: bidv)

            ticks.append(.init(time: time, askp: askp, bidp: bidp, askv: askV, bidv: bidV))
        }

        return ticks
    }
}
