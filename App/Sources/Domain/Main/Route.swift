//
//  Route.swift
//  Walkie
//
//  Created by sanghyeon on 8/1/25.
//

import Foundation
import CoreLocation

/// 도메인 레이어의 산책 코스 엔티티
struct Route: Equatable {
    var name: String
    var geometry: [Geometry]
    var weight: Double
    var duration: Double
    var distance: Double
    
    init(
        name: String,
        geometry: [Geometry],
        weight: Double = 0,
        duration: Double = 0,
        distance: Double? = nil
    ) {
        self.name = name
        self.geometry = geometry
        self.weight = weight

        if let distance {
            self.duration = duration
            self.distance = distance
        } else {
            let distance = Self.totalDistance(from: geometry)
            self.distance = distance
            self.duration = Self.walkingTime(distanceMeters: self.distance)
        }
    }
    
    /// Geometry 배열로부터 전체 거리를 계산
    private static func totalDistance(from geometries: [Geometry]) -> Double {
        guard geometries.count > 1 else { return 0 }
        
        var total: Double = 0
        for i in 0..<(geometries.count - 1) {
            let start = CLLocation(
                latitude: geometries[i].latitude,
                longitude: geometries[i].longitude
            )
            let end = CLLocation(
                latitude: geometries[i + 1].latitude,
                longitude: geometries[i + 1].longitude
            )
            
            total += start.distance(from: end)
        }
        
        return total
    }
    
    private static func walkingTime(distanceMeters: Double, speedKmh: Double = 4.5) -> Double {
        let speedMps = speedKmh * 1000 / 3600
        return distanceMeters / speedMps / 60 // 분 단위
    }
}

/// 위경도 한 점
struct Geometry: Equatable {
    var longitude: Double
    var latitude: Double
}

/// 코스 리스트 + 메타데이터
struct RouteData {
    let routes: [Route]
    let totalCount: Int
}
