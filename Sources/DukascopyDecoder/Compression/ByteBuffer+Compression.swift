//
//  Created by Vitali Kurlovich on 23.05.22.
//

import NIO
import NIOFoundationCompat
import SWCompression

extension ByteBuffer {
    func decompress() throws(LZMAError) -> ByteBuffer? {
        guard let data = try getData(at: 0, length: readableBytes, byteTransferStrategy: .noCopy)?.decompress() else {
            return nil
        }

        return ByteBuffer(data: data)
    }
}
