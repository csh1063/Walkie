//
//  KakaoMapProps.swift
//  TakeAWalk
//
//  Created by sanghyeon on 7/30/25.
//

import Foundation

struct KakaoMapProps {
    
    var mapRevision: Int
    
    var datas: [Route]
    var moveMode: KakaoMapTrackingMode
    var drawMode: KakaoMapDrawMode
    
    var mapState: Bool
    var userLatitude: Double
    var userLongitude: Double
    
    var onEvent: (KakaoMapEvent) -> Void
}

enum KakaoMapEvent: Equatable {
    case updateDatas(Route)
    case moveMap(KakaoMapTrackingMode)
}
