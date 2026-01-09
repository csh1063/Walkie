//
//  SplashRepository.swift
//  TakeAWalk
//
//  Created by sanghyeon on 9/17/25.
//

import Foundation
import ComposableArchitecture

struct SplashRepository {
    var initialize: () async throws -> String
}

// {{Feature}}.dependency(\.splashRepository, .live)
// \.appClient 부분
extension DependencyValues {
    var splashRepository: SplashRepository {
        get { self[SplashRepository.self] }
        set { self[SplashRepository.self] = newValue }
    }
}

// .live 부분
extension SplashRepository: DependencyKey {
    static let liveValue: SplashRepository = {
        
        let client = NetworkManager<SplashAPI>()
        
        return Self(
            initialize: {
                let result: SplashInitRes = try await client.request(.splash)
                return result.message
            }
        )
    }()
}

