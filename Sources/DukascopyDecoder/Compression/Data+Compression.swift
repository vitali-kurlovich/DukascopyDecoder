//
//  Compression.swift
//  VetChat
//
//  Created by Vitali Kurlovich on 11/15/18.
//  Copyright © 2018 SIA Mystic Moments. All rights reserved.
//

import Foundation

enum LZMAError: Error {
    case encodingError
    case internalError
    case invalidFormat
}

#if canImport(Compression)
    import Compression

    internal
    extension Data {
        @available(OSX 10.11, *)

        func decompress() throws -> Data {
            try withUnsafeBytes { (source) -> Data in
                let config = (operation: COMPRESSION_STREAM_DECODE, algorithm: COMPRESSION_LZMA)
                return try perform(config, source: source, sourceSize: count)
            }
        }
    }

    private
    typealias Config = (operation: compression_stream_operation, algorithm: compression_algorithm)

    @available(OSX 10.11, *)
    private
    func perform(_ config: Config, source: UnsafeRawBufferPointer, sourceSize: Int, preload: Data = Data()) throws -> Data {
        guard config.operation == COMPRESSION_STREAM_ENCODE || sourceSize > 0 else {
            throw LZMAError.invalidFormat
        }

        let streamBase = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
        defer { streamBase.deallocate() }
        var stream = streamBase.pointee

        let status = compression_stream_init(&stream, config.operation, config.algorithm)
        guard status != COMPRESSION_STATUS_ERROR else {
            throw LZMAError.encodingError
        }
        defer { compression_stream_destroy(&stream) }

        let bufferSize = Swift.max(Swift.min(sourceSize, 64 * 1024), 64)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }

        guard let src_ptr = source.bindMemory(to: UInt8.self).baseAddress else {
            throw LZMAError.internalError
        }

        stream.dst_ptr = buffer
        stream.dst_size = bufferSize
        stream.src_ptr = src_ptr
        stream.src_size = sourceSize

        var res = preload
        let flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)

        while true {
            switch compression_stream_process(&stream, flags) {
            case COMPRESSION_STATUS_OK:
                guard stream.dst_size == 0 else {
                    throw LZMAError.internalError
                }
                res.append(buffer, count: stream.dst_ptr - buffer)
                stream.dst_ptr = buffer
                stream.dst_size = bufferSize

            case COMPRESSION_STATUS_END:
                res.append(buffer, count: stream.dst_ptr - buffer)
                return res

            case COMPRESSION_STATUS_ERROR:
                throw LZMAError.encodingError
            default:
                throw LZMAError.internalError
            }
        }
    }

#else

    import SWCompression

    extension Data {
        func decompress() throws -> Data {
            try LZMA.decompress(data: self)
        }
    }

#endif
