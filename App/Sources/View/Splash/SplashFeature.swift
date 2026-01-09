//
//  SplashFeature.swift
//  TakeAWalk
//
//  Created by sanghyeon on 6/25/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct SplashFeature {
    
    struct State: Equatable {
        var isLoading = false
        var errorMessage: String?
    }

    enum Action {
        case onAppear
        case initializationResponse(Result<String, Error>)
        case initializationCompleted
        case endAnimation
    }
    
    @Dependency(\.splashRepository) var appClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let message = try await appClient.initialize()
                        await send(.initializationResponse(.success(message)))
                    } catch {
                        await send(.initializationResponse(.failure(error)))
                    }
                }
            case let .initializationResponse(.success(message)):
                print("message: \(message)")
                state.isLoading = false
                return .none
            case let .initializationResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case .endAnimation:
                return .send(.initializationCompleted)
            case .initializationCompleted:
                return .none
            }
        }
    }
}
