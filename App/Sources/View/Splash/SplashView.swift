//
//  SplashView.swift
//  TakeAWalk
//
//  Created by sanghyeon on 6/22/25.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    
    let store: StoreOf<SplashFeature>
    
    @State private var animate = false
    private let duration = 1.0
    
    var body: some View {
        WithViewStore(store,
                      observe: { $0 }) { viewStore in
            VStack {
                Text("Splash!!")
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1 : 0.5)
                    .animation(.easeOut(duration: duration), value: animate)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onChange(of: viewStore.isLoading) { isLoaded in
                if !isLoaded {
                    animate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        viewStore.send(.endAnimation)
                    }
                }
            }
        }
    }
}

//#Preview {
//    SplashView()
//}
