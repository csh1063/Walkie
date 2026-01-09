//
//  SplashAPI.swift
//  TakeAWalk
//
//  Created by sanghyeon on 7/5/25.
//

import Foundation
import Moya

enum SplashAPI: BaseAPI {
    
    case splash
    
    var baseURL: URL {
        guard let url = URL(string: Server.url + "/splash") else {
            fatalError("\(Server.url)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .splash:
            return "/init"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        default: return [:]
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
