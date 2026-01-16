//
//  CourseRecomRes.swift
//  Walkie
//
//  Created by sanghyeon on 8/1/25.
//

import Foundation

struct CourseRecomRes: Decodable {
    let routes: [RouteRes]
    let totalCount: Int
}

struct RouteRes: Decodable {
    let name: String
    let geometry: GeometryRes
    let weight: Double
    let duration: Double
    let distance: Double
}

struct GeometryRes: Decodable {
    let coordinates: [[Double]]
    let type: String
}

struct RouteAddParam: Encodable {
    let name: String
    let geometry: [[Double]]
    let distance: Double
}
