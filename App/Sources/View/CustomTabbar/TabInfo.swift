//
//  TabData.swift
//  View
//
//  Created by sanghyeon on 3/12/25.
//  Copyright © 2025 sanghyeon. All rights reserved.
//

import SwiftUI

enum TabInfo: Int, CaseIterable {
    case list = 0
    case map = 1
    case my = 2
    
    var title: String {
        switch self {
        case .list: return "리"
        case .map: return "맵"
        case .my: return "마"
        }
    }
    
    var image: String {
        switch self {
        case .list: return "1.circle.fill"
        case .map: return "2.circle.fill"
        case .my: return "3.circle.fill"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .list: return "1.square.fill"
        case .map: return "2.square.fill"
        case .my: return "3.square.fill"
        }
    }
    
    static var items: [TabItem] {
        
        var items: [TabItem] = []
        for item in allCases {
            items.append(
                TabItem(id: item.rawValue,
                        title: item.title,
                        normalImageName: item.image,
                        selectedImageName: item.selectedImage)
            )
        }
        
        return items
    }
    
    static func by(_ index: Int) -> TabInfo {
        switch index {
        case 0: return .list
        case 1: return .map
        case 2: return .my
        default: return .map
        }
    }
    
//    @ViewBuilder
//    static func byView(_ index: Int) -> some View {
//        switch index {
//        case 1: UserSUView()
//        case 2: CustomMapView()
//        case 3: MyPageView()
//        default: HomeView()
//        }
//    }
}
