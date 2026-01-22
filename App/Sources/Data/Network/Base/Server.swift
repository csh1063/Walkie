//
//  Server.swift
//  Walkie
//
//  Created by sanghyeon on 7/5/25.
//

import Foundation

enum ServerType {
    case dev
    case prod
    case stage
}

struct Server {
    #if DEBUG
    static var type: ServerType = .dev
    #else
    static var type: ServerType = .prod
    #endif
    
    static var url: String {
        switch self.type {
//        case .dev:
//        case .prod:
//        case .stage:
//        default: return "http://127.0.0.1:3000"
//        default: return "http://169.254.118.191:3000" //집
        default: return "http://169.254.114.7:3000" // 폰
            
        }
    }
}
