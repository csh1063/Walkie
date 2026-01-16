//
//  CourseUseCase.swift
//  TakeAWalk
//
//  Created by GPT on 1/9/26.
//

import Foundation
import ComposableArchitecture

/// 코스 관련 도메인 유스케이스 집합
struct CourseUseCase {
    /// 코스 추천 요청
    var recommendCourse: () async throws -> RouteData
    /// 코스 추가
    var addRoute: (Route) async throws -> Bool
}

extension DependencyValues {
    var courseUseCase: CourseUseCase {
        get { self[CourseUseCase.self] }
        set { self[CourseUseCase.self] = newValue }
    }
}

extension CourseUseCase: DependencyKey {
    static let liveValue: CourseUseCase = {
        // Data 레이어의 구현체를 주입받음 (의존성 역전)
        let repository: CourseRepositoryProtocol = LiveCourseRepository()
        
        return CourseUseCase(
            recommendCourse: {
                // 비즈니스 로직: 데이터 검증 및 가공
                let data = try await repository.recommendCourse()
                
                // 빈 결과 검증
                guard !data.routes.isEmpty else {
                    throw CourseError.mappingError("추천 코스가 없습니다")
                }
                
                // 유효한 코스만 필터링 (거리가 0보다 큰 코스만)
                let validRoutes = data.routes.filter { route in
                    route.distance > 0 && !route.geometry.isEmpty
                }
                
                guard !validRoutes.isEmpty else {
                    throw CourseError.invalidRoute("유효한 코스가 없습니다")
                }
                
                return RouteData(
                    routes: validRoutes,
                    totalCount: validRoutes.count
                )
            },
            addRoute: { route in
                // 비즈니스 로직: 코스 유효성 검증
                try Self.validateRoute(route)
                
                // Route를 CourseAddParam으로 변환
                let param = route.toAddParam()
                
                // Repository를 통해 저장
                return try await repository.addRoute(param)
            }
        )
    }()
    
    // MARK: - Private Helper Methods
    
    /// 코스 유효성 검증
    private static func validateRoute(_ route: Route) throws {
        // 이름 검증
        guard !route.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CourseError.invalidRoute("코스 이름이 비어있습니다")
        }
        
        // Geometry 검증 (최소 2개 이상의 점 필요)
        guard route.geometry.count >= 2 else {
            throw CourseError.invalidRoute("코스는 최소 2개 이상의 지점이 필요합니다")
        }
        
        // 거리 검증
        guard route.distance > 0 else {
            throw CourseError.invalidRoute("코스 거리가 0보다 커야 합니다")
        }
    }
}

// MARK: - Route Extension

extension Route {
    /// Route를 CourseAddParam으로 변환
    func toAddParam() -> CourseAddParam {
        let geometry: [[Double]] = self.geometry.map { 
            [$0.longitude, $0.latitude]
        }
        
        return CourseAddParam(
            name: self.name,
            geometry: geometry,
            distance: self.distance
        )
    }
}

