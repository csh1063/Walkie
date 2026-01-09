//
//  TWError.swift
//  TakeAWalk
//
//  Created by sanghyeon on 7/5/25.
//

import Moya

enum TWError: Error {
    case networkError(String, Int)
    case decodingError(String, Int)
    case unknown(Error)

    init(from moyaError: MoyaError) {
        
        let statusCode = moyaError.response?.statusCode ?? -999
        
        switch moyaError {
        case .underlying(let error, _):
            self = .networkError(error.localizedDescription, statusCode)
        case .objectMapping(_, _):
            self = .decodingError("Decoding error", statusCode)
        default:
            self = .unknown(moyaError)
        }
    }
}
