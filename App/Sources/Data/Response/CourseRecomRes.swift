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
    let id: Int
    let name: String
    let geometry: GeometryRes
    let duration: Double
    let distance: Double
    let lineColor: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, geometry, duration, distance
        case lineColor = "line_color"
        case created = "created_at"
    }
}

struct GeometryRes: Decodable {
    let coordinates: [[Double]]
    let type: String
}

struct RouteAddParam: Encodable {
    let name: String
    let geometry: [[Double]]
    let distance: Double
    let lineColor: String
}
