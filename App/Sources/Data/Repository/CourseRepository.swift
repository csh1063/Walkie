//
//  CourseRepository.swift
//  TakeAWalk
//
//  Created by sanghyeon on 9/17/25.
//

import Foundation
import ComposableArchitecture

struct CourseRepository {
    var recommendCourse: () async throws -> RouteData
    var addRoute: (RouteAddParam) async throws -> Bool
}

// {{Feature}}.dependency(\.courseRepository, .live)
// \.appClient 부분
extension DependencyValues {
    var courseRepository: CourseRepository {
        get { self[CourseRepository.self] }
        set { self[CourseRepository.self] = newValue }
    }
}

// .live 부분
extension CourseRepository: DependencyKey {
    static let liveValue: CourseRepository = {
        
        let client = NetworkManager<CourseAPI>()
        
        return Self(
            recommendCourse: {
                let result: CourseRecomRes = try await client.request(.recommend)
                
                return result.toDomain()
            },
            addRoute: { param in
                let result: BaseSuccess = try await client.request(.add(param))
                
                return true
            }
        )
    }()
}
