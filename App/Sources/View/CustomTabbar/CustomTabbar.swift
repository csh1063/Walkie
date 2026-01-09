//
//  CustomTabbar.swift
//  Presentation
//
//  Created by sanghyeon on 7/6/25.
//  Copyright © 2025 sanghyeon. All rights reserved.
//

import SwiftUI

struct CustomTabbar: View {
    
    @Binding var selected: Int
    
    var body: some View {
        
        HStack(spacing: 0) {
            Spacer(minLength: 20)
            ForEach(TabInfo.items) { item in
                CustomTabItem(item: item, selected: self.$selected)
            }
            Spacer(minLength: 20)
        }
    }
}

//#Preview {
//    CustomTabbarView()
//}
