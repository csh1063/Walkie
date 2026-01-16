//
//  CourseRepositoryProtocol.swift
//  Walkie
//
//  Domain 레이어에서 정의하는 Repository 추상화
//

import Foundation

/// 코스 추가를 위한 파라미터 (Domain 레이어)
struct CourseAddParam {
    let name: String
    let geometry: [[Double]]
    let distance: Double
}

/// 코스 데이터 소스 추상화 (Domain 레이어)
protocol CourseRepositoryProtocol {
    /// 코스 추천 데이터 조회
    func recommendCourse() async throws -> RouteData
    
    /// 새로운 코스 추가
    func addRoute(_ param: CourseAddParam) async throws -> Bool
}
