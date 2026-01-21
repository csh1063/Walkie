//
//  MainFeature.swift
//  Walkie
//
//  Created by sanghyeon on 6/25/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import CoreLocation

@Reducer
struct MainFeature {
    
    struct State: Equatable {
        
        var isLoading = false
        var errorMessage: String?
        var courseError: CourseError?
        
        var mapRevision: Int = -1
        var mapState: Bool = true
        var userLatitude: Double = 37.498268
        var userLongitude: Double = 127.026906
        var datas: [Route] = []
        var totalCount: Int = 0
        
        var moveMode: KakaoMapTrackingMode = .moveCurrent
        var drawMode: KakaoMapDrawMode = .none
        
        var add: AddFeature.State?
        
    }
    
    enum Action {
        case onAppear
        case loadData
        case drawData(RouteData)
        case updateData(Route)
        case updateLocation(Double, Double)
        case changeMapState(Bool)
        case setMoveMode(KakaoMapTrackingMode)
        case setDrawMode(KakaoMapDrawMode)
        case handleError(CourseError)
        case clearError
        
        
        case addButtonTapped(Route)
        case add(AddFeature.Action)
        case addDismissed
    }
    
    @Dependency(\.courseUseCase) var courseUseCase
    @Dependency(\.locationClient) var locationClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.loadData),
                    .run { send in
                        await locationClient.requestAuthorization()
                        
                        for await coord in locationClient.startUpdating() {
                            await send(.updateLocation(coord.latitude, coord.longitude))
                        }
                    }
                )
            case .loadData:
                state.isLoading = true
                state.errorMessage = nil
                state.courseError = nil
                return .run { send in
                    do {
                        let result = try await courseUseCase.recommendCourse()
                        await send(.drawData(result))
                    } catch let error as CourseError {
                        await send(.handleError(error))
                    } catch {
                        await send(.handleError(.unknown(error.localizedDescription)))
                    }
                }
            case let .drawData(result):
                state.isLoading = false
                state.mapRevision += 1
                state.datas = result.routes
                state.totalCount = result.totalCount
                return .none
            case .updateData(let data):
//                state.isLoading = true
                state.errorMessage = nil
                state.courseError = nil
                
                return .send(.addButtonTapped(data))
//                return .run { send in
//                    do {
//                        _ = try await courseUseCase.addRoute(data)
//                        await send(.loadData)
//                    } catch let error as CourseError {
//                        await send(.handleError(error))
//                    } catch {
//                        await send(.handleError(.unknown(error.localizedDescription)))
//                    }
//                }
            case let .handleError(error):
                state.isLoading = false
                state.courseError = error
                state.errorMessage = error.errorDescription
                print("에러 발생: \(error.errorDescription ?? "알 수 없는 오류")")
                return .none
            case .clearError:
                state.errorMessage = nil
                state.courseError = nil
                return .none
            case let .updateLocation(latitude, longitude):
                state.userLatitude = latitude
                state.userLongitude = longitude
                print("latitude", latitude)
                print("longitude", longitude)
                return .none
            case let .changeMapState(mapState):
                state.mapState = mapState
                if mapState {
                    return .send(.onAppear)
                } else {
                    return .run { send in
                        locationClient.stopUpdating()
                    }
                }
            case .setMoveMode(let mode):
                state.moveMode = mode
                print("setMoveMode", state.moveMode)
                return .none
            case .setDrawMode(let mode):
                state.drawMode = mode
                print("setDrawMode", state.moveMode)
                return .none
                //            default: return .none
                
            case let .addButtonTapped(data):
                state.add = AddFeature.State(
                    data: data
                )
                return .none
            case .add(.delegate(.didSave)):
                // 부모 상태 업데이트
                print("저장됨!")
                
                state.add = nil
//                return .none
                return .send(.loadData)
            case .add(.delegate(.didCancel)):
                state.add = nil
                return .none
            case .addDismissed:
                state.add = nil
                return .none
            case .add:
                return .none
//            case .add(.saveTapped):
//                print("메인 저장")
//                return .none
//            case .add(.handleError(_)):
//                <#code#>
            }
        }
        .ifLet(\.add, action: \.add) {
            AddFeature()
                .dependency(\.courseUseCase, .liveValue)
        }
    }
}
