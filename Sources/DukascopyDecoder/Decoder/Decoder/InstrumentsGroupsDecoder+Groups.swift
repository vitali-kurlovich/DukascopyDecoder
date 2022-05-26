//
//  Created by Vitali Kurlovich on 26.05.22.
//

import Foundation

extension InstrumentsGroupsDecoder {
    func groups(_ source: Finstruments) -> [Group] {
        let instruments = source.instruments.compactMapValues {
            ($0.filename?.isEmpty ?? true) ? nil : Instrument($0)
        }

        let groups = source.groups.values.sorted { $0.id < $1.id }

        return groups.compactMap { group -> Group? in
            group.parent == nil ? self.group(for: group, instruments: instruments, groups: groups) : nil
        }
    }

    func group(for src: Finstruments.Group,
               instruments: [String: Instrument],
               groups: [Finstruments.Group]) -> Group
    {
        let groupInstruments = src.instruments?.compactMap { instruments[$0] }.sorted(by: { $0.symbol < $1.symbol }) ?? []

        let subgroups = groups.filter { $0.parent == src.id }.map { item -> Group in
            group(for: item, instruments: instruments, groups: groups)
        }.compactMap { $0.instruments.isEmpty && $0.groups.isEmpty ? nil : $0 }

        return Group(id: src.id,
                     title: src.title,
                     instruments: groupInstruments,
                     groups: subgroups)
    }
}
