//
//  AddFeature.swift
//  Walkie
//
//  Created by sanghyeon on 1/20/26.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import CoreLocation

@Reducer
struct AddFeature {
    
    struct State: Equatable {
        var title: String = ""
        var data: Route
    }

    enum Action {
        case titleChanged(String)
        case saveTapped
        case delegate(Delegate)
        case handleError(CourseError)
        
        enum Delegate {
            case didSave
            case didCancel
        }
    }
    
    @Dependency(\.courseUseCase) var courseUseCase

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .titleChanged(text):
                state.title = text
                return .none

            case .saveTapped:
                print("saveTapped")
                
                state.data.name = state.title
                let data = state.data
                
                return .run { send in
                    do {
                        _ = try await courseUseCase.addRoute(data)
                        await send(.delegate(.didSave))
                    } catch let error as CourseError {
                        await send(.handleError(error))
                    } catch {
                        await send(.handleError(.unknown(error.localizedDescription)))
                    }
                }
                
            case .delegate:
                return .none
            case let .handleError(error):
//                state.isLoading = false
//                state.courseError = error
//                state.errorMessage = error.errorDescription
                print("에러 발생: \(error.errorDescription ?? "알 수 없는 오류")")
                return .none
            }
        }
    }
}
