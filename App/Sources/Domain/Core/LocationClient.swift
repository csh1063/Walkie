//
//  LocationClient.swift
//  Walkie
//
//  Domain 레이어에서 사용하는 위치 추상화
//

import CoreLocation

public struct LocationClient {
    public var requestAuthorization: @Sendable () async -> Void
    public var startUpdating: @Sendable () -> AsyncStream<CLLocationCoordinate2D>
    public var stopUpdating: @Sendable () -> Void
}

