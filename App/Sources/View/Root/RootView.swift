//
//  RootView.swift
//  Walkie
//
//  Created by sanghyeon on 6/19/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: StoreOf<RootFeature>
    
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
}
