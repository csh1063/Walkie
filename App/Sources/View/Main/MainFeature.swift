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
        
        var mapRevision: Int = -1
        var mapState: Bool = true
        var userLatitude: Double = 37.498268
        var userLongitude: Double = 127.026906
        var datas: [Route] = []
        var totalCount: Int = 0
        
        var moveMode: KakaoMapTrackingMode = .moveCurrent
        var drawMode: KakaoMapDrawMode = .none
        
        
//        func props(event: @escaping (KakaoMapEvent) -> Void) -> KakaoMapProps {
//            return KakaoMapProps(datas: self.datas,
//                                 mode: self.mode,
//                                 mapState: self.mapState,
//                                 userLatitude: self.userLatitude,
//                                 userLongitude: self.userLongitude,
//                                 onEvent: event)
//        }
    }

    enum Action {//}: Equatable {
        case onAppear
        case loadData
        case drawData(RouteData)
        case updateData(Route)
        case updateLocation(Double, Double)
        case changeMapState(Bool)
        case setMoveMode(KakaoMapTrackingMode)
        case setDrawMode(KakaoMapDrawMode)
    }
    
    @Dependency(\.courseRepository) var courseRepository
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
                return .run { send in
                    do {
                        let result = try await courseRepository.recommendCourse()
                        await send(.drawData(result))
                    } catch {
                        
                    }
                }
            case let .drawData(result):
                print("good", result)
                state.mapRevision += 1
                state.datas = result.routes
                state.totalCount = result.totalCount
                return .none
            case .updateData(let data):
//                state.datas.append(data)
                return .run { send in
                    
                    let result = try await courseRepository.addRoute(data.param)
                    
                    await send(.loadData)
                }
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
