//
//  PolylineView.swift
//  Walkie
//
//  Created by sanghyeon on 1/21/26.
//

import SwiftUI

struct PolylineView: View {
    let coordinates: [Geometry]

    var body: some View {
        GeometryReader { geo in
            let points = normalizePointsKeepRatio(
                coordinates: coordinates,
                size: geo.size
            )
            
            Path { path in
//                let points = points.map ({ CGPoint(x: $0.longitude, y: $0.latitude) })
                guard let first = points.first else { return }
                path.move(to: first)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(
                .blue,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
//            .stroke(.blue, lineWidth: 3)
        }
    }
    
    func normalizePoints(
        coordinates: [Geometry],
        size: CGSize,
        padding: CGFloat = 16
    ) -> [CGPoint] {

        let lats = coordinates.map { $0.latitude }
        let lons = coordinates.map { $0.longitude }

        guard
            let minLat = lats.min(),
            let maxLat = lats.max(),
            let minLon = lons.min(),
            let maxLon = lons.max(),
            maxLat != minLat,
            maxLon != minLon
        else { return [] }

        let drawableWidth = size.width - padding * 2
        let drawableHeight = size.height - padding * 2

        return coordinates.map {
            let x = ($0.longitude - minLon) / (maxLon - minLon) * drawableWidth + padding
            let y = drawableHeight
                - (($0.latitude - minLat) / (maxLat - minLat) * drawableHeight)
                + padding

            return CGPoint(x: x, y: y)
        }
    }
    
    func normalizePointsKeepRatio(
        coordinates: [Geometry],
        size: CGSize,
        padding: CGFloat = 16
    ) -> [CGPoint] {

        let lats = coordinates.map { $0.latitude }
        let lons = coordinates.map { $0.longitude }

        guard
            let minLat = lats.min(),
            let maxLat = lats.max(),
            let minLon = lons.min(),
            let maxLon = lons.max(),
            maxLat != minLat,
            maxLon != minLon
        else { return [] }

        let routeWidth = maxLon - minLon
        let routeHeight = maxLat - minLat

        let drawableWidth = size.width - padding * 2
        let drawableHeight = size.height - padding * 2

        let scale = min(
            drawableWidth / routeWidth,
            drawableHeight / routeHeight
        )

        let offsetX = (size.width - routeWidth * scale) / 2
        let offsetY = (size.height - routeHeight * scale) / 2

        return coordinates.map {
            let x = ($0.longitude - minLon) * scale + offsetX
            let y = (maxLat - $0.latitude) * scale + offsetY
            return CGPoint(x: x, y: y)
        }
    }

}
