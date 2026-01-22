//
//  KakaoMapView.swift
//  View
//
//  Created by sanghyeon on 3/13/25.
//  Copyright © 2025 sanghyeon. All rights reserved.
//

import Foundation
import KakaoMapsSDK
import SwiftUI
import UIKit

fileprivate enum Literals {
    static let viewName = "mapview"
    static let viewInfoName = "map"
    static let currentLayer = "currentLayer"
    static let flagLayer = "flagLayer"
    static let routeLayer = "routeLayer"
}

enum KakaoMapTrackingMode {
    case free
    case moveCurrent
//    case trackCurrent
    
    var next: KakaoMapTrackingMode {
        return switch self {
        case .free: .moveCurrent
        case .moveCurrent: .free
        }
    }
}

enum KakaoMapDrawMode {
    case none
    case pin
    case tracking
}

struct KakaoMapView: UIViewRepresentable {
    
//    var props: KakaoMapProps
    
    var isEnable: Bool
    var state: KakaoMapState
    var current: KakaoMapCurrent
    var data: KakaoMapData
    var onEvent: (KakaoMapEvent) -> Void
    
    /// UIView를 상속한 KMViewContainer를 생성한다.
    /// 뷰 생성과 함께 KMControllerDelegate를 구현한 Coordinator를 생성하고, 엔진을 생성 및 초기화한다.
    func makeUIView(context: Self.Context) -> KMViewContainer {
        
        //        let view: KMViewContainer = KMViewContainer()
        let view: KMViewContainer = KMViewContainer(//frame: .zero)
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
        )
//        container.translatesAutoresizingMaskIntoConstraints = false
        
        view.sizeToFit()
        context.coordinator.createController(view)
        context.coordinator.controller?.prepareEngine()

        return view
    }
    
    
    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    /// draw가 true로 설정되면 엔진을 시작하고 렌더링을 시작한다.
    /// draw가 false로 설정되면 렌더링을 멈추고 엔진을 stop한다.
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if isEnable {
//        if draw {
            context.coordinator.controller?.activateEngine()
//            context.coordinator.props = props
            context.coordinator.state = state
            context.coordinator.current = current
            context.coordinator.data = data
            context.coordinator.onEvent = onEvent
            context.coordinator.updatePosition()
        } else {
            context.coordinator.controller?.pauseEngine()
        }
    }
    
    /// Coordinator 생성
    func makeCoordinator() -> KakaoMapCoordinator {
//        return KakaoMapCoordinator(props: self.props)
        return KakaoMapCoordinator(
            state: state,
            current: current,
            data: data,
            onEvent: onEvent
        )
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
    
    // MARK: - Coordinator
    /// Coordinator 구현. KMControllerDelegate를 adopt한다.
    class KakaoMapCoordinator: NSObject, MapControllerDelegate, KakaoMapEventDelegate {
        
        var controller: KMController?
        
//        var props: KakaoMapProps
        var state: KakaoMapState
        var current: KakaoMapCurrent
        var data: KakaoMapData
        var onEvent: (KakaoMapEvent) -> Void
        
        var local: [Route] = []
        
        var nowMapVersion: Int = -1
        
        var mapMode: KakaoMapTrackingMode {
//            return props.moveMode
            return state.moveMode
        }
        
        private var isModeChange: Bool = false
        
        private var newRoute: Route?
        private var drawedName: [String] = []
        
        private var startTime: TimeInterval?
        private var endTime: TimeInterval?
        
        var latitude: Double {
            self.current.userLatitude
        }
        var longitude: Double {
            self.current.userLongitude
        }
        
        var endDatas: [String: [MapPoint]] = [:]
        var mapDatas: [MapPoint] = []

        private var map: KakaoMap?
        private var myPositionPoi: Poi?
        
//        init(props: KakaoMapProps) {
//            self.props = props
//        }
        
        init(state: KakaoMapState,
             current: KakaoMapCurrent,
             data: KakaoMapData,
             onEvent: @escaping (KakaoMapEvent) -> Void) {
            self.state = state
            self.current = current
            self.data = data
            self.onEvent = onEvent
        }
 
        // MARK: Custom
        func updateCurrentPositionPoi() {
            myPositionPoi?.moveAt(MapPoint(longitude: self.longitude, latitude: self.latitude), duration: 300)
        }
        
        func clear() {
            print("clear!")
                                
            guard let map = self.map else {return}
            
            let routeManager = map.getRouteManager()
            routeManager.removeRouteLayer(layerID: Literals.routeLayer)
//            let layer = map.getRouteManager().getRouteLayer(layerID: Literals.routeLayer)
//            layer?.clearAllRoutes()
            
            let labelLayer = map.getLabelManager().getLabelLayer(layerID: Literals.flagLayer)
            labelLayer?.clearAllItems()
            
            self.drawedName = []
        }
        
        func removeRoute() {
            
        }
        
        func removePoi() {
            
        }
        
        func updatePosition() {
            
            if self.nowMapVersion != self.data.mapRevision {
                self.nowMapVersion = self.data.mapRevision

                self.clear()
                self.createRouteLayer()
            }
            
            self.updateCurrentPositionPoi()
            switch self.mapMode {
            case .free: break
            case .moveCurrent:
                self.isModeChange = true
                self.moveCurrentPosition()
            }
            
            switch self.state.drawMode {
            case .none:
                if let newRoute = self.newRoute {
                    let name = randomString(length: 10)
                    print("name \(name)")
                    
                    let route: Route
                    
                    if let startTime = self.startTime {
                        let endTime = Date().timeIntervalSince1970
                        print("endTime \(endTime)")
                        
                        route = Route(name: name,
                                      geometry: newRoute.geometry,
                                      duration: endTime - startTime)
                    } else {
                        route = Route(name: name,
                                      geometry: newRoute.geometry)
                    }
                    
                    self.onEvent(.updateDatas(route))
                    
                    self.newRoute = nil
                }
                break
            case .pin:
                break
            case .tracking:
                if self.mapDatas.count == 0 {
                    self.moveCurrentPosition()
                }
                drawLine(longitude: self.longitude, latitude: self.latitude)
            }
            self.drawRoute()
        }
        
        func randomString(length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in letters.randomElement()! })
        }
        
        func moveCurrentPosition() {
            
            guard let map = self.map else {
                return
            }
            
            let camera = CameraUpdate.make(
                target: MapPoint(longitude: longitude,
                                 latitude: latitude),
                mapView: map)
            
            map.moveCamera(camera)
        }
        
        // MARK: Delegate
        func containerDidUpdateFrame(_ container: KMViewContainer) {
            // 컨테이너 프레임이 업데이트될 때 호출
            print("container frame updated")
            container.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 400, height: 600))//parent.frame // 중요: 컨테이너 크기 업데이트
            container.setNeedsLayout()
            container.layoutIfNeeded()
        }
        
        // KMController 객체 생성 및 event delegate 지정
        func createController(_ view: KMViewContainer) {//, latitude: Double, longitude: Double) {
            controller = KMController(viewContainer: view)
            controller?.delegate = self
            
//            print("latitude:", self.latitude)
//            print("longitude:", self.longitude)
        }
        
        // KMControllerDelegate Protocol method구현
        /// 엔진 생성 및 초기화 이후, 렌더링 준비가 완료되면 아래 addViews를 호출한다.
        /// 원하는 뷰를 생성한다.
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: self.longitude, latitude: self.latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(
                viewName: Literals.viewName,
                viewInfoName: Literals.viewInfoName,
                defaultPosition: defaultPosition,
                defaultLevel: 18)
            
            controller?.addView(mapviewInfo)
        }
        
        //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
            
            guard let map = controller?.getView(Literals.viewName) as? KakaoMap else {
                return
            }
            
            self.map = map
            map.eventDelegate = self
            map.setGestureEnable(type: .rotate, enable: false)
            map.setGestureEnable(type: .tilt, enable: false)
            map.cameraMinLevel = 3
            map.cameraMaxLevel = 21
            map.poiScale = .regular
            
            self.createLabelLayer()
            self.createCurrentPoi()
//            self.createRouteLayer()
        }
        
        //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
        func addViewFailed(_ viewName: String, viewInfoName: String) {
            print("Failed")
        }
        
        /// KMViewContainer 리사이징 될 때 호출.
        func containerDidResized(_ size: CGSize) {
        }
        
        func cameraWillMove(kakaoMap: KakaoMapsSDK.KakaoMap, by: MoveBy) {

            if !self.isModeChange, mapMode != .free {
                self.onEvent(.moveMap(.free))
            }
        }
        
        func cameraDidStopped(kakaoMap: KakaoMapsSDK.KakaoMap, by: MoveBy) {
            self.isModeChange = false
        }
        func kakaoMapDidTapped(kakaoMap: KakaoMapsSDK.KakaoMap, point: CGPoint) {
            print("kakaoMapDidTapped x: \(point.x), y: \(point.y)")
        }
        
        func terrainDidTapped(kakaoMap: KakaoMapsSDK.KakaoMap, position: KakaoMapsSDK.MapPoint) {
            print("terrainDidTapped long: \(position.wgsCoord.longitude), lat: \(position.wgsCoord.latitude)")
            
            if self.state.drawMode == .pin {
                
                self.drawLine(longitude: position.wgsCoord.longitude,
                              latitude: position.wgsCoord.latitude)
            }
        }
        
        private func drawLine(longitude: Double, latitude: Double) {
            
            if self.newRoute == nil {
                self.startTime = Date().timeIntervalSince1970
                print("startTime \(startTime ?? 0)")
                self.newRoute = Route(name: "new",
                                  geometry: [Geometry(longitude: longitude,
                                                      latitude: latitude)])
            } else {
                self.newRoute?.geometry.append(Geometry(longitude: longitude,
                                                        latitude: latitude))
            }
            
            if let route = self.newRoute {
                self.drawRoute(route)
            }
        }
        
        // MARK: Private
        private func createLabelLayer() {
            guard let map = self.map else {
                return
            }
            
            let currentLayerOption = LabelLayerOptions(
                layerID: Literals.currentLayer,
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 9999
            )
            
            let pickLayerOption = LabelLayerOptions(
                layerID: Literals.flagLayer,
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 5000
            )
            
            let manager = map.getLabelManager()
            let _ = manager.addLabelLayer(option: currentLayerOption)
            let _ = manager.addLabelLayer(option: pickLayerOption)
        }
        
        private func createRouteLayer() {
            guard let map = self.map else {
                return
            }
            
            let manager = map.getRouteManager()
            let _ = manager.addRouteLayer(layerID: Literals.routeLayer, zOrder: 4000)
            
            let styleSet = RouteStyleSet(styleID: "route", styles: [])
//            styleSet.addPattern(RoutePattern(pattern: UIImage(systemName: "1.circle.fill")!, distance: 2, symbol: nil, pinStart: true, pinEnd: true))
            
            let routeStyle = RouteStyle(styles: [PerLevelRouteStyle(width: 2, color: UIColor.systemMint, strokeWidth: 2, strokeColor: UIColor.blue, level: 5, patternIndex: 1)])
            
            styleSet.addStyle(routeStyle)
            
            let routeStyle2 = RouteStyle(styles: [PerLevelRouteStyle(width: 2, color: UIColor.systemOrange, strokeWidth: 2, strokeColor: UIColor.red, level: 7, patternIndex: 2)])
            
            styleSet.addStyle(routeStyle2)
            
            manager.addRouteStyleSet(styleSet)
            
//            self.drawRoute()
        }
        
        private func drawRoute() {
            let routes = makeRoute()
            
            for route in routes where !self.drawedName.contains(route.name) {
                self.drawRoute(route)
            }
        }
        
        private func drawRoute(_ route: Route) {
            
            guard let map = self.map else {
                return
            }
            
            let manager = map.getRouteManager()
            let layer = manager.getRouteLayer(layerID:  Literals.routeLayer)
            
            let routeID = route.name
            let value = route.toMapPoints()
            
            if value.count > 1 {
                let seg = RouteSegment(points: value, styleIndex: 0)
                
                print("drawRoute key", routeID)
                if let route = layer?.getRoute(routeID: routeID) {
                    route.changeStyleAndData(styleID: "route", segments: [seg])
                    route.show()
                } else {
                    let option = RouteOptions(routeID: routeID, styleID: "route", zOrder: 3000)
                    option.segments = [seg]
                    
                    let route = layer?.addRoute(option: option)
                    route?.show()
                }
            }
            
            self.drawRoutePoi(route)
            
            if routeID != "name" {
                self.drawedName.append(routeID)
            }
        }
        
        private func makeRoute() -> [Route] {
            
            var result = self.data.datas
            
            result.append(contentsOf: self.local)
            if let newRoute = self.newRoute {
                result.append(newRoute)
            }
            
            return result
        }
        
        private func createCurrentPoi() {
            
            guard let manager = self.map?.getLabelManager() else {
                return
            }
            let type = CustomPoiType.current
            
            manager.addPoiStyle(type.poiStyle)
            
            let myPosition = MapPoint(
                longitude: self.longitude,
                latitude: self.latitude
            )
            
            let layer = manager.getLabelLayer(layerID: Literals.currentLayer)
            myPositionPoi = layer?.addPoi(option: type.poiOption("current"), at: myPosition)
            myPositionPoi?.show()
        }
        
        private func drawRoutePoi(_ route: Route) {
            
            guard let manager = self.map?.getLabelManager() else {
                return
            }
            
            let type = CustomPoiType.pick
            let startPoiOption = type.poiOption("\(route.name)_start")
            let endName = "\(route.name)_end"
            
            manager.addPoiStyle(type.poiStyle)
            
            let layer = manager.getLabelLayer(layerID: Literals.flagLayer)
            if let first = route.geometry.first {
                _ = layer?.addPoi(option: startPoiOption, at: MapPoint(longitude: first.longitude, latitude: first.latitude))
            }
            
            if let end = route.geometry.last, route.geometry.count > 1 {
                let endPoint = MapPoint(longitude: end.longitude,
                                        latitude: end.latitude)
                if let endPoi = layer?.getPoi(poiID: endName) {
                    endPoi.moveAt(endPoint, duration: 100)
                } else {
                    let endPoiOption = type.poiOption(endName)
                    _ = layer?.addPoi(option: endPoiOption, at: endPoint)
                }
            }

            layer?.showAllPois()
        }
    }
}

extension MoveBy {
    var text: String {
        switch self {
        case .doubleTapZoomIn: return "한 손가락 더블탭 줌인"
        case .twoFingerTapZoomOut: return "두 손가락 싱글탭 줌 아웃"
        case .pan: return "패닝"
        case .rotate: return "회전"
        case .zoom: return "줌"
        case .tilt: return "틸트"
        case .longTapAndDrag: return "롱탭 후 드래그"
        case .rotateZoom: return "회전 및 줌 동시"
        case .oneFingerZoom: return "한 손가락 줌"
        case .notUserAction: return "그외 기타"
        @unknown default:
            return "what?"
        }
    }
}

extension Route {
    func toMapPoints() -> [MapPoint] {
        return geometry.map { $0.toMapPoint() }
    }
}

extension Geometry {
    func toMapPoint() -> MapPoint {
        return MapPoint(longitude: longitude, latitude: latitude)
    }
}
