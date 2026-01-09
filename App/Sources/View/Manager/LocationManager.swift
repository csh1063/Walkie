//
//  LocationManager.swift
//  TakeAWalk
//
//  Created by sanghyeon on 7/15/25.
//

import Foundation
import CoreLocation
import Combine

//final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//
//    @Published var coordinate: CLLocationCoordinate2D?
//    @Published var authorizationStatus: CLAuthorizationStatus?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        coordinate = locations.last?.coordinate
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
////    
////        switch manager.authorizationStatus {
////        case .authorizedAlways, .authorizedWhenInUse:
////            locationManager.startUpdatingLocation()
////        case .restricted, .notDetermined, .denied:
////            AlertManager.setLocationAuthentication()
////        default:
////            print("GPS: Default")
////        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("fail to update location")
//    }
//}


final class CLLocationManagerWrapper: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var authContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var continuation: AsyncStream<CLLocationCoordinate2D>.Continuation?
    
//    private var lastLocation: CLLocation? {
//        didSet {
//            print("lastLocation", self.lastLocation)
//        }
//    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
    }

    func startUpdating() -> AsyncStream<CLLocationCoordinate2D> {
        manager.startUpdatingLocation()
        return AsyncStream { continuation in
            self.continuation = continuation
        }
    }


    func stopUpdating() {
        print("stop???")
        manager.stopUpdatingLocation()
        continuation?.finish()
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = locations.last {
            continuation?.yield(coord.coordinate)
            print("didUpdateLocations longitude:", coord.coordinate.longitude, ", latitude", coord.coordinate.latitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 에러:", error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
        print("ffffff")
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: authorized")
        case .restricted, .notDetermined, .denied:
            print("GPS: denied")
        default:
            print("GPS: Default")
        }
    }
}


import ComposableArchitecture

public struct LocationClient {
    public var requestAuthorization: @Sendable () async -> Void
    public var startUpdating: @Sendable () -> AsyncStream<CLLocationCoordinate2D>
    public var stopUpdating: @Sendable () -> Void
}

extension LocationClient: DependencyKey {
    public static let liveValue: LocationClient = {
        let manager = CLLocationManagerWrapper()

        return LocationClient(
            requestAuthorization: {
                manager.requestAuthorization()
            },
            startUpdating: {
                manager.startUpdating()
            },
            stopUpdating: {
                manager.stopUpdating()
            }
        )
    }()
}

extension DependencyValues {
    public var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}


//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    
//    @Published var currentLocation: CLLocationCoordinate2D?
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    func requestLocation() {
//        manager.requestWhenInUseAuthorization()
//        manager.requestLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last?.coordinate
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("위치 가져오기 실패:", error.localizedDescription)
//    }
//}
