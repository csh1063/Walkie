import SwiftUI
import SwiftData
import ComposableArchitecture
import CoreLocation

struct MainView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode
    
    let store: StoreOf<MainFeature>
    
    //    @State private var draw: Bool = false
    @State private var selection: Int = 0
    @State var showLocation: Bool = false
    @State var boxOpacity: Double = 0
    @State var boxBottom: Double = -400
    
    var body: some View {
        WithViewStore(store,
                      observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) {
                
                let props = KakaoMapProps(
                    mapRevision: viewStore.mapRevision,
                    datas: viewStore.datas,
                    moveMode: viewStore.moveMode,
                    drawMode: viewStore.drawMode,
                    mapState: viewStore.mapState,
                    userLatitude: viewStore.userLatitude,
                    userLongitude: viewStore.userLongitude,
                    onEvent: { event in
                        
                        DispatchQueue.main.async {
                            switch event {
                            case .updateDatas(let data):
                                viewStore.send(.updateData(data))
                            case .moveMap(let mode):
                                viewStore.send(.setMoveMode(mode))
                            }
                        }
                    })
                
                KakaoMapView(props: props)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.container)
                    .onAppear(perform: {
                        viewStore.send(.changeMapState(true))
                    }).onDisappear(perform: {
                        viewStore.send(.changeMapState(false))
                    })
                    .onChange(of: scenePhase) { phase in    // 화면 phase
                        switch phase {
                        case .active:
                            print("app active")
                            viewStore.send(.changeMapState(true))
                        default:
                            print("app inactive or background")
                            viewStore.send(.changeMapState(false))
                        }
                    }
                
                HStack(spacing: 12) {
                    // 내 위치 버튼
                    Button {
                        viewStore.send(.setMoveMode(.moveCurrent))
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                            
                            Image(systemName: "location.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // 그리기 버튼
                    Button {
                        switch viewStore.drawMode {
                        case .none:
                            viewStore.send(.setDrawMode(.pin))
                        case .pin:
                            viewStore.send(.setDrawMode(.none))
                        case .tracking: break
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: viewStore.drawMode == .pin ? "xmark.circle.fill" : "pencil")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text(viewStore.drawMode == .pin ? "종료" : "그리기")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(viewStore.drawMode == .pin ? .white : .blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(viewStore.drawMode == .pin ? Color.blue : Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
                    }
                    .disabled(viewStore.drawMode == .tracking)
                    .opacity(viewStore.drawMode == .tracking ? 0.5 : 1.0)
                    
                    // 트래킹 버튼
                    Button {
                        switch viewStore.drawMode {
                        case .none:
                            viewStore.send(.setDrawMode(.tracking))
                        case .pin: break
                        case .tracking:
                            viewStore.send(.setDrawMode(.none))
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: viewStore.drawMode == .tracking ? "stop.circle.fill" : "record.circle")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text(viewStore.drawMode == .tracking ? "종료" : "트래킹")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(viewStore.drawMode == .tracking ? .white : .green)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(viewStore.drawMode == .tracking ? Color.red : Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
                    }
                    .disabled(viewStore.drawMode == .pin)
                    .opacity(viewStore.drawMode == .pin ? 0.5 : 1.0)
                    
                    Button {
                        viewStore.send(.loadData)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                
                CustomTabbar(selected: self.$selection)
                    .padding(.bottom, 20)
                    .background(Color.white)
                
                if self.showLocation {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.bottom, boxBottom)
                }
                
                
                
                IfLetStore(
                    store.scope(state: \.add, action: \.add)
                ) { addStore in

                    // dim
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    AddView(store: addStore)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container)
            .onAppear {
            }
        }
    }
    
    private func showBox() {
        self.showLocation = true
        withAnimation(.easeInOut(duration: 0.2)) {
            self.boxBottom = 200
        }
    }
    
    private func hideBox() {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.boxBottom = -400
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showLocation = false
        }
    }
}
