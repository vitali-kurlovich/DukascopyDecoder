//
//  Created by Vitali Kurlovich on 25.05.22.
//

import Foundation

public
final class InstrumentsGroupsDecoder {
    let decoder = InstrumentsInfoDecoder()

    public
    func decode(with data: Data) throws -> [Group] {
        let result = try decoder.decode(with: data)

        return groups(result)
    }
}