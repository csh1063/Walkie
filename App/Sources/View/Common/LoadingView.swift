//
//  LoadingView.swift
//  Walkie
//
//  Created by sanghyeon on 2/10/26.
//

import SwiftUI
import Foundation

struct LoadingView: View {
    
    var body: some View {
        ZStack(alignment: .center) {
            // dim
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            Text("Loading...")
                .foregroundStyle(Color.white)
                .font(.headline)
        }
    }
}
