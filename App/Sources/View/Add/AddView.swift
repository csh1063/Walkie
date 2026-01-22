//
//  AddView.swift
//  Walkie
//
//  Created by sanghyeon on 1/20/26.
//

import SwiftUI
import ComposableArchitecture

struct AddView: View {
    
    let store: StoreOf<AddFeature>
    
    var body: some View {
        WithViewStore(store,
                      observe: {$0}) { viewStore in
            VStack {
                Spacer()
                VStack(alignment: .center, spacing: 16) {

                    Text("추가하기")
                        .font(.headline)
                    
                    TextField(
                        "제목",
                        text: viewStore.binding(
                            get: \.title,
                            send: AddFeature.Action.titleChanged
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Text("거리")
                            .font(.subheadline)
                        Spacer()
                        Text(formatDistance(viewStore.data.distance))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("시간")
                            .font(.subheadline)
                        Spacer()
                        Text(formatDuration(viewStore.data.duration))
                            .foregroundColor(.gray)
                    }

                    PolylineView(coordinates: viewStore.data.geometry)
                        .frame(height: 120)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    HStack {
                        Button {
                            viewStore.send(.delegate(.didCancel))
                        } label: {
                            HStack(spacing: 6) {
                                Text("취소")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
                        }
                        
                        Button {
                            viewStore.send(.saveTapped)
                        } label: {
                            HStack(spacing: 6) {
                                Text("저장")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
                        }
                    }
                }
                .padding(.vertical, 100)
                .padding(.horizontal, 40)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                Spacer()
            }
        }
    }
    
    func formatDistance(_ meters: Double) -> String {
        if meters >= 1000 {
            let km = (meters / 1000 * 10).rounded() / 10
            return "\(String(format: "%.1f", km)) km"
        } else {
            let m = (meters * 10).rounded() / 10
            return "\(String(format: "%.1f", m)) m"
        }
    }
    
    func formatDuration(_ sec: Double) -> String {
        var h: Int, m: Int, s: Int = 0
        s = Int(sec) % 60
        m = Int(sec / 60) % 60
        h = Int(sec / 60 / 60)
        
        var components: [String] = []

        // 시 출력
        if h > 0 {
            components.append("\(h)시간")
        }

        // 분 출력
        if m > 0 || h > 0 { // 시가 있으면 0분도 출력
            let minStr = h > 0 ? String(format: "%02d분", m) : "\(m)분"
            components.append(minStr)
        }

        // 초 출력
        let secStr: String
        if h > 0 || m > 0 {
            secStr = String(format: "%02d초", s)
        } else {
            secStr = "\(s)초"
        }
        components.append(secStr)

        return components.joined(separator: " ")
    }
}
