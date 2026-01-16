//
//  MainFeature.swift
//  TakeAWalk
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

//                return .run { send in
//                    await locationClient.requestAuthorization()
//                    
//                    async let load: () = {
//                        let result = try await appClient.recommendCourse()
//                        await send(.loadDatas(result.routes))
//                    }()
//                    
//                    async let track: () = {
//                        for await coord in locationClient.startUpdating() {
//                            await send(.updateLocation(coord.latitude, coord.longitude))
//                        }
//                    }()
//                    
//                    _ = try await (load, track)
//                }
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
                state.isLoading = true
                state.errorMessage = nil
                state.courseError = nil
                return .run { send in
                    do {
                        _ = try await courseUseCase.addRoute(data)
                        await send(.loadData)
                    } catch let error as CourseError {
                        await send(.handleError(error))
                    } catch {
                        await send(.handleError(.unknown(error.localizedDescription)))
                    }
                }
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
            default: return .none
            }
        }
    }
}
