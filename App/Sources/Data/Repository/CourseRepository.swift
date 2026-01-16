//
//  CourseRepository.swift
//  TakeAWalk
//
//  Created by sanghyeon on 9/17/25.
//

import Foundation
import Moya

/// CourseRepositoryProtocol의 실제 구현체 (Data 레이어)
final class LiveCourseRepository: CourseRepositoryProtocol {
    private let client: NetworkManager<CourseAPI>
    
    init(client: NetworkManager<CourseAPI> = NetworkManager<CourseAPI>()) {
        self.client = client
    }
    
    func recommendCourse() async throws -> RouteData {
        do {
            let result: CourseRecomRes = try await client.request(.recommend)
            return result.toDomain()
        } catch let error as TWError {
            // Data 레이어 에러를 Domain 에러로 변환
            throw mapToDomainError(error)
        } catch {
            throw CourseError.unknown(error.localizedDescription)
        }
    }
    
    func addRoute(_ param: CourseAddParam) async throws -> Bool {
        do {
            // Domain 타입을 Data 타입으로 변환
            let routeAddParam = RouteAddParam(
                name: param.name,
                geometry: param.geometry,
                distance: param.distance
            )
            let _: BaseSuccess = try await client.request(.add(routeAddParam))
            return true
        } catch let error as TWError {
            // Data 레이어 에러를 Domain 에러로 변환
            throw mapToDomainError(error)
        } catch {
            throw CourseError.unknown(error.localizedDescription)
        }
    }
    
    // MARK: - Private Helper
    
    /// Data 레이어 에러를 Domain 에러로 변환
    private func mapToDomainError(_ error: TWError) -> CourseError {
        switch error {
        case .networkError(let message, let code):
            return .networkError("\(message) (코드: \(code))")
        case .decodingError(let message, let code):
            return .mappingError("\(message) (코드: \(code))")
        case .unknown(let underlyingError):
            return .unknown(underlyingError.localizedDescription)
        }
    }
}
