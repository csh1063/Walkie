//
//  CustomPoiType.swift
//  Walkie
//
//  Created by sanghyeon on 7/7/25.
//

import Foundation
import UIKit
import KakaoMapsSDK

enum CustomPoiType: CaseIterable {
    
    case current
    case pick
    
    static var layers: [String] {
        return Array(Set(self.allCases.map {$0.layerName}))
    }
    
    var layerName: String {
        switch self {
        case .current: return "currentLayer"
        case .pick: return "pickLayer"
        }
    }
    
    var styleID: String {
        switch self {
        case .current: return "current"
        case .pick: return "pick"
        }
    }
    
    var poiImage: UIImage? {
        switch self {
        case .current: return UIImage(systemName: "1.square.fill")?
                .withRenderingMode(.alwaysTemplate)
                .withTintColor(UIColor.red)
        case .pick: return UIImage(systemName: "3.square.fill")?
                .withRenderingMode(.alwaysTemplate)
                .withTintColor(UIColor.blue)
        }
    }
    
    var poiStyle: PoiStyle {
        let anchorPoint = CGPoint(x: 0, y: 0)
        let icon = PoiIconStyle(
            symbol: self.poiImage,
            anchorPoint: anchorPoint
        )
        
        let text = PoiTextStyle(textLineStyles: [
            PoiTextLineStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.orange))
        ])
        
        return PoiStyle(
            styleID: self.styleID,
            styles: [
                PerLevelPoiStyle(iconStyle: icon, level: 0),
                PerLevelPoiStyle(textStyle: text, level: 1)
            ]
        )
    }
    
    func poiOption(_ name: String) -> PoiOptions {

        let poiOption = PoiOptions(
            styleID: self.styleID,
            poiID: name)
        poiOption.rank = 0
        poiOption.clickable = false
        
        switch self {
        case .current: break
        case .pick:
            poiOption.addText(PoiText(text: name, styleIndex: 1))
        }
        
        return poiOption
    }
}
