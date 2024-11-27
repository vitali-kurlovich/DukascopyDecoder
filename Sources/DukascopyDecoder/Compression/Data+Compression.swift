//
//  Created by Vitali Kurlovich on 11/15/18.
//  Copyright © 2018 SIA Mystic Moments. All rights reserved.
//

import Foundation
import SWCompression

extension Data {
    func decompress() throws(LZMAError) -> Data {
        do {
            return try LZMA.decompress(data: self)
        } catch {
            if let lzmaError = error as? LZMAError {
                throw lzmaError
            }

            throw LZMAError.wrongProperties
        }
    }
}
