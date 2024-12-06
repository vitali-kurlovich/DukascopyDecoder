//
//  Data+Compression.swift
//  DukascopyDecoder
//
//  Created by Vitali Kurlovich on 7.12.24.
//

import Foundation

extension Data {
    func decompress() throws -> Data {
        let mutableData = NSMutableData(data: self)
        try mutableData.decompress(using: .lzma)
        return mutableData as Data
    }
}
