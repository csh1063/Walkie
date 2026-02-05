//
//  RouteColor.swift
//  Walkie
//
//  Created by sanghyeon on 2/5/26.
//

import SwiftUI
import UIKit

enum RouteColor: UInt, CaseIterable {
    case blue = 0
    case red = 1
    case orange = 2
    case yellow = 3
    case mint = 4
    case green = 5
    case purple = 6
    case black = 7
    case gray = 8
    case pink = 9
    case cyan = 10
    
    static func type(_ color: String) -> Self {
        switch color {
        case "blue": return .blue
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "mint": return .mint
        case "green": return .green
        case "purple": return .purple
        case "black": return .black
        case "gray": return .gray
        case "pink": return .pink
        case "cyan": return .cyan
        default: return .blue
        }
    }
    
    var text: String {
        switch self {
        case .blue: return "blue"
        case .red: return "red"
        case .orange: return "orange"
        case .yellow: return "yellow"
        case .mint: return "mint"
        case .green: return "green"
        case .purple: return "purple"
        case .black: return "black"
        case .gray: return "gray"
        case .pink: return "pink"
        case .cyan: return "cyan"
        }
    }
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .mint: return .mint
        case .green: return .green
        case .purple: return .purple
        case .black: return .black
        case .gray: return .gray
        case .pink: return .pink
        case .cyan: return .cyan
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .mint: return .systemMint
        case .green: return .green
        case .purple: return .purple
        case .black: return .black
        case .gray: return .gray
        case .pink: return .systemPink
        case .cyan: return .cyan
        }
    }
}
