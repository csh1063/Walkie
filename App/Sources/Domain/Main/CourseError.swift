//
//  CourseError.swift
//  Walkie
//
//  코스 관련 도메인 에러 타입
//

import Foundation

/// 코스 관련 도메인 에러
enum CourseError: LocalizedError, Equatable {
    /// 네트워크 에러
    case networkError(String)
    /// 데이터 변환 에러
    case mappingError(String)
    /// 유효하지 않은 코스 데이터
    case invalidRoute(String)
    /// 서버 에러
    case serverError(String)
    /// 알 수 없는 에러
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .mappingError(let message):
            return "데이터 변환 오류: \(message)"
        case .invalidRoute(let message):
            return "유효하지 않은 코스: \(message)"
        case .serverError(let message):
            return "서버 오류: \(message)"
        case .unknown(let message):
            return "알 수 없는 오류: \(message)"
        }
    }
}
