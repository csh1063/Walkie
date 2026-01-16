//
//  BaseAPI.swift
//  Walkie
//
//  Created by sanghyeon on 7/5/25.
//

import UIKit
import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL {
        guard let url = URL(string: Server.url) else {
            fatalError("\(Server.url)")
        }
        
        return url
    }
    
    var headers: [String: String]? {
//        let info = Bundle.main.infoDictionary
//        let appVersion = info?["CFBundleShortVersionString"] as? String ?? "Unknown"
//        let version = ProcessInfo.processInfo.operatingSystemVersion
//        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        let header: [String: String] = ["LoggerKey": "\(Date()) \(Date().timeIntervalSince1970)"]
//        header["Authorization"] = "Bearer \(LoginUsersData.shared.accessToken)"
//        header["userDeviceInfo"] = "iOS(\(appVersion); \(UIDevice.modelName); \(versionString))"
        
        return header
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
