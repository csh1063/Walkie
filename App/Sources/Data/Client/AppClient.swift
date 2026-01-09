//
//  APPClient.swift
//  TakeAWalk
//
//  Created by sanghyeon on 6/23/25.
//

import Foundation
import Combine
import CombineMoya
import Moya
import ComposableArchitecture

//class AppClient {
//    func initialize() async throws -> SplashInitRes {
//        let provider = BaseProvider<SplashAPI>()
//        return try await NetworkManager(provider: provider).request(.splash)
//    }
//    
//    func recommendCourse() async throws -> CourseRecomRes {
//        print("recommendCourse")
//        let provider = BaseProvider<CourseAPI>()
//        return try await NetworkManager(provider: provider).request(.recommend)
//    }
//    
//    func addRoute(param: ReouteAddParam) async throws -> BaseNull {
//        
//        let provider = BaseProvider<CourseAPI>()
//        return try await NetworkManager(provider: provider)
//            .request(.add(param))
//    }
//}
