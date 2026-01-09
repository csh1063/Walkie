//
//  CourseAPI.swift
//  TakeAWalk
//
//  Created by sanghyeon on 8/1/25.
//
import Foundation
import Moya

enum CourseAPI: BaseAPI {
    
    case recommend
    case add(RouteAddParam)
    
    var baseURL: URL {
        guard let url = URL(string: Server.url + "/course") else {
            fatalError("\(Server.url)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .recommend:
            return "/recommend"
        case .add:
            return "/add"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .add: return .post
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
        case .add(let param):
            return .requestJSONEncodable(param)
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
