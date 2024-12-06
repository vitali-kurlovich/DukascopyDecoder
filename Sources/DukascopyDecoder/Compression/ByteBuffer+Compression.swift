//
//  Created by Vitali Kurlovich on 23.05.22.
//

import NIO
import NIOFoundationCompat
import Foundation

extension ByteBuffer {
    func decompress() throws -> ByteBuffer? {
        guard let data = getData(at: 0, length: readableBytes, byteTransferStrategy: .noCopy) else {
            return nil
        }
        
        let mutableData = NSMutableData(data: data)
        try mutableData.decompress(using: .lzma)
        
        let decompressed = mutableData as Data
        
        return ByteBuffer(data: decompressed)
    }
}
