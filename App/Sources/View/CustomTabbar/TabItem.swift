//
//  CustomTabItem.swift
//  View
//
//  Created by sanghyeon on 3/11/25.
//  Copyright © 2025 sanghyeon. All rights reserved.
//

import SwiftUI

struct TabItem: Identifiable {
    var id: Int = 0
    var title: String?
    var normalImage: Image?
    var normalImageName: String?
    var selectedImage: Image?
    var selectedImageName: String?
}
