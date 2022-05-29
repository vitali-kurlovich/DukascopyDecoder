//
//  Created by Vitali Kurlovich on 25.05.22.
//

import DukascopyModel
import Foundation

public
struct InstrumentsGroupsDecoder {
    let decoder = InstrumentsInfoDecoder()

    public
    init() {}
}

public
extension InstrumentsGroupsDecoder {
    func decode(with data: Data) throws -> [Group] {
        let result = try decoder.decode(with: data)

        return groups(result)
    }
}
