//
//  NetworkManager.swift
//  TakeAWalk
//
//  Created by sanghyeon on 7/5/25.
//

import Combine
import Moya
import CombineMoya
import Foundation
import ComposableArchitecture

protocol NetworkManagerProtocol {
    associatedtype APIType
    
    func request(_ api: APIType) -> AnyPublisher<Response, MoyaError>
    func request<T: Decodable>(_ api: APIType) async throws -> BaseResponse<T>
}

final class NetworkManager<APIType: TargetType>: NetworkManagerProtocol {
//    typealias APIType = U
    private var provider: BaseProvider<APIType>
    
    init() {
        self.provider = BaseProvider<APIType>()
    }
    
    func request(_ api: APIType) -> AnyPublisher<Response, MoyaError> {
        provider.requestPublisher(api)
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(_ api: APIType) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(BaseResponse<T>.self, from: response.data)
                        if data.result {
                            continuation.resume(returning: data.data)
                        } else {
                            continuation.resume(throwing: TWError.decodingError("no data", -999))
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
