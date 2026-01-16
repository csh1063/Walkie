//
//  RootFeature.swift
//  Walkie
//
//  Created by sanghyeon on 6/22/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct RootFeature {
    
    // MARK: - State
    struct State: Equatable {
        var route: Route = .splash
        var splash = SplashFeature.State()
        var main = MainFeature.State()
        
        enum Route: Equatable {
            case splash
            case main
        }
    }
    
    // MARK: - Action
    enum Action {
        case splash(SplashFeature.Action)
        case main(MainFeature.Action)
        case routeChanged(State.Route)
    }
    
    // MARK: - Body (Reducer)
    var body: some ReducerOf<Self> {
        Scope(state: \.splash, action: \.splash) {
            SplashFeature()
                .dependency(\.splashRepository, .liveValue)
        }
        Scope(state: \.main, action: \.main) {
            MainFeature()
                .dependency(\.locationClient, .liveValue)
                .dependency(\.courseUseCase, .liveValue)
        }
        Reduce { state, action in
            switch action {
            case .splash(.initializationCompleted):
                state.route = .main
                return .none
            default:
                return .none
            }
        }
    }
}
