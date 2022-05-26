
//
//  Created by Vitali Kurlovich on 26.05.22.
//

import Foundation

import DukascopyModel
import NIO

extension InstrumentsGroupsDecoder {
    func decode(with buffer: ByteBuffer) throws -> [Group] {
        let result = try decoder.decode(with: buffer)
        return groups(result)
    }
}
