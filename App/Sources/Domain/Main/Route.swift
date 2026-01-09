//
//  Route.swift
//  TakeAWalk
//
//  Created by sanghyeon on 8/1/25.
//

import Foundation
import CoreLocation

struct Route: Equatable {
    var name: String
    var geometry: [Geometry]
    var weight: Double
    var duration: Double
    var distance: Double = 0
    
    var param: RouteAddParam {
        
        let geometry: [[Double]] = self.geometry.map { return [$0.longitude, $0.latitude]
        }
        
        return RouteAddParam(name: self.name,
                             geometry: geometry,
                             distance: self.distance)
    }
    
    init(name: String, geometry: [Geometry], weight: Double = 0, duration: Double = 0, distance: Double? = nil) {
        self.name = name
        self.geometry = geometry
        self.weight = weight
        self.duration = duration
        if let distance = distance {
            self.distance = distance
        } else {
            self.distance = self.totalDistance(from: geometry)// distance
        }
    }
    
    func totalDistance(from geometries: [Geometry]) -> Double {
        guard geometries.count > 1 else { return 0 }
        
        var total: Double = 0
        for i in 0..<(geometries.count - 1) {
            let start = CLLocation(latitude: geometries[i].latitude,
                                   longitude: geometries[i].longitude)
            let end = CLLocation(latitude: geometries[i+1].latitude,
                                 longitude: geometries[i+1].longitude)
            
            total += start.distance(from: end)
        }
        
        return total
    }
}

struct Geometry: Equatable {

    var longitude: Double
    var latitude: Double
}

struct RouteData {
    let routes: [Route]
    let totalCount: Int
}

extension CourseRecomRes {
    func toDomain() -> RouteData {
        return RouteData(routes: self.routes.map {$0.toDomain()},
                         totalCount: self.totalCount)
    }
}

extension RouteRes {
    func toDomain() -> Route {
        return Route(name: self.name,
                     geometry: self.geometry.toDomain(),
                     distance: self.distance)
    }
}

extension GeometryRes {
    func toDomain() -> [Geometry] {
        return self.coordinates.filter {
            $0.count >= 2
        }.map {
            Geometry(longitude: $0[0], latitude: $0[1])
        }
    }
}
