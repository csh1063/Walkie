//
//  ColorGridView.swift
//  Walkie
//
//  Created by sanghyeon on 2/5/26.
//


import SwiftUI

struct ColorGridView: View {

    let colors: [RouteColor] = RouteColor.allCases
    var selectedColor: String
    let onSelect: (String) -> Void

    @State private var width: CGFloat = 0
    
    private let columnsCount = 5
    private let spacing: CGFloat = 8
    private let maxVisibleRows = 2

    private var rowCount: Int {
        Int(ceil(Double(colors.count) / Double(columnsCount)))
    }

    var body: some View {
        
        let itemSize = (width - spacing * CGFloat(columnsCount - 1)) / CGFloat(columnsCount)

        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.fixed(itemSize), spacing: spacing),
                    count: columnsCount
                ),
                spacing: spacing
            ) {
                if width > 0 {
                    ForEach(colors.indices, id: \.self) { index in
                        colorButton(
                            color: colors[index].color,
                            size: itemSize,
                            isSelected: selectedColor == colors[index].text
                        ) {
                            let colorString = colors[index].text
                            onSelect(colorString)
                        }
                    }
                }
            }
            .padding(.vertical, spacing)
        }
        .frame(height: gridHeight(itemSize: itemSize))
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { width = geo.size.width }
                    .onChange(of: geo.size.width) { width = $0 }
            }
        )
    }

    // 높이 계산
    private func gridHeight(itemSize: CGFloat) -> CGFloat? {
        guard rowCount > maxVisibleRows else { return nil }

        return CGFloat(maxVisibleRows) * itemSize
            + CGFloat(maxVisibleRows - 1) * spacing
            + spacing * 2
    }

    // 공통 버튼
    private func colorButton(
        color: Color,
        size: CGFloat,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            let outerPadding: CGFloat = 4
            let radius = min(12, ((size - outerPadding * 2) / 2))
            color
                .cornerRadius(radius)
                .padding(3)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(isSelected ? .black : .clear, lineWidth: 3)
                )
                .padding(outerPadding)
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
    }
}
