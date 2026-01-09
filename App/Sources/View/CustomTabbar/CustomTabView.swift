//
//  CustomTabView.swift
//  View
//
//  Created by sanghyeon on 3/11/25.
//  Copyright © 2025 sanghyeon. All rights reserved.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var selected: Int
    var innerViews: [AnyView]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            innerViews[selected % innerViews.count]
                .ignoresSafeArea()
//            Tab.byView(selected)
//                .ignoresSafeArea()
            CustomTabbar(selected: self.$selected)
        }
//        .ignoresSafeArea(edges: .top)
    }
}

//#Preview {
//    @State var selection = 0
//    CustomTabView(selected: $selection)
//}
