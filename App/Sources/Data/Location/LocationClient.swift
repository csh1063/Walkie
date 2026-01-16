//
//  LocationClient.swift
//  TakeAWalk
//
//  Created by GPT on 1/9/26.
//

import Foundation
import CoreLocation
import ComposableArchitecture

// MARK: - CLLocationManager Wrapper (Data Layer 구현)

final class CLLocationManagerWrapper: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: AsyncStream<CLLocationCoordinate2D>.Continuation?
    
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
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: authorized")
        case .restricted, .notDetermined, .denied:
            print("GPS: denied")
        @unknown default:
            print("GPS: Default")
        }
    }
}

// MARK: - TCA Dependency (LocationClient 구현 바인딩)

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

