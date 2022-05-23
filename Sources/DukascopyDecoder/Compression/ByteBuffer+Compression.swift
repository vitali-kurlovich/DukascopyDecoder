//
//  Created by Vitali Kurlovich on 23.05.22.
//

import Foundation
import SWCompression

import NIO
import NIOFoundationCompat

extension ByteBuffer {
    func decompress() throws -> ByteBuffer? {
        guard let data = try getData(at: 0, length: readableBytes, byteTransferStrategy: .noCopy)?.decompress() else {
            return nil
        }

        return ByteBuffer(data: data)
    }
}
