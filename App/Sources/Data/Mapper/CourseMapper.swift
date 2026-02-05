//
//  CourseMapper.swift
//  Walkie
//
//  Created by GPT on 1/9/26.
//

import Foundation

/// Data(Response) -> Domain 변환 로직
extension CourseRecomRes {
    func toDomain() -> RouteData {
        RouteData(
            routes: routes.map { $0.toDomain() },
            totalCount: totalCount
        )
    }
}

extension RouteRes {
    func toDomain() -> Route {
        Route(
            id: id,
            name: name,
            geometry: geometry.toDomain(),
            distance: distance,
            lineColor: lineColor,
            created: created
        )
    }
}

extension GeometryRes {
    func toDomain() -> [Geometry] {
        coordinates
            .filter { $0.count >= 2 }
            .map { Geometry(longitude: $0[0], latitude: $0[1]) }
    }
}

