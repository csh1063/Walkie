//
//  RootView.swift
//  TakeAWalk
//
//  Created by sanghyeon on 6/19/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: StoreOf<RootFeature>
    
//    @State var isLoaded: Bool = false
//    
//    public init(store: StoreOf<RootFeature>) {
//      self.store = store
//    }
//    
    var body: some View {
        WithViewStore(self.store, observe: \.route) { viewStore in
            switch viewStore.state {
            case .splash:
                SplashView(
                    store: store.scope(state: \.splash, action: \.splash)
                )
            case .main:
                MainView(
                    store: store.scope(state: \.main, action: \.main)
                )
            }
        }
    }
//    var body: some View {
////        switch store.case {
////        case let .splash(store):
////            SplashView(store: store)
////        case let .main(store):
////            MainView(store: store)
////        }
//        WithViewStore(store, observe: {$0}) { viewStore in
//            
//            if viewStore.splash?.isEndSplash == true {
//                MainView(store: StoreOf<MainFeature>(
//                    initialState: MainFeature.State.init(),
//                    reducer: { MainFeature() })
//                )
//            } else {
//                SplashView(store: StoreOf<SplashFeature>(
//                    initialState: SplashFeature.State.init(),
//                    reducer: { SplashFeature() })
//                )
//            }
//        }
////        if !self.isLoaded {
////            SplashView(store: StoreOf<SplashFeature>(
////                initialState: SplashFeature.State.init(),
////                reducer: { SplashFeature() })
////            )
////        } else {
////            SplashView(store: StoreOf<SplashFeature>(
////                initialState: SplashFeature.State.init(),
////                reducer: { SplashFeature() })
////            )
////        }
//    }
}

//#Preview {
//    RootView()
//}
