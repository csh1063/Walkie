//
//  CustomTabItem.swift
//  Presentation
//
//  Created by sanghyeon on 7/6/25.
//  Copyright © 2025 sanghyeon. All rights reserved.
//

import SwiftUI

struct CustomTabItem: View {
    
    @State var item: TabItem
    
    @Binding var selected: Int
    
    var body: some View {
        
            Button(action: {
                selected = item.id
            }, label: {
                VStack(spacing: 4) {
                    Image(systemName: item.id == selected ? item.selectedImageName ?? "":item.normalImageName ?? "")
                    Text(item.title ?? "btn")
                        .font(Font.system(size: 12))
                }
            })
            .frame(height: 52)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

//#Preview {
//    CustomTabItemView()
//}
