//
//  Created by Vitali Kurlovich on 11/15/18.
//  Copyright © 2018 SIA Mystic Moments. All rights reserved.
//

import Foundation
import SWCompression

extension Data {
    func decompress() throws -> Data {
        try LZMA.decompress(data: self)
    }
}
