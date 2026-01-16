//
//  BaseResponse.swift
//  Walkie
//
//  Created by sanghyeon on 7/5/25.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let result: Bool
    let data: T
}

struct BaseNull: Decodable {
    
}

struct BaseSuccess: Decodable {
    let success: Bool
}
