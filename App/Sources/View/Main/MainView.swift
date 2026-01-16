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
                
                HStack {
                    Button {
                        viewStore.send(.setMoveMode(.moveCurrent))
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
                            .overlay {
                                Image(systemName: "dot.scope")
//                                Text("내 위치")
                            }
                    }
                    
//                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    Button {
                        switch viewStore.drawMode {
                        case .none:
                            viewStore.send(.setDrawMode(.pin))
                        case .pin:
                            viewStore.send(.setDrawMode(.none))
                        case .tracking: break
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
//                            .frame(width: 120, height: 40)
                            .overlay {
                                switch viewStore.drawMode {
                                case .none: Text("그리기")
                                case .pin: Text("종료")
                                case .tracking: Text("-")
                                        .foregroundStyle(Color.gray)
                                }
                            }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    Button {
                        switch viewStore.drawMode {
                        case .none:
                            viewStore.send(.setDrawMode(.tracking))
                        case .pin: break
                        case .tracking:
                            viewStore.send(.setDrawMode(.none))
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
//                            .frame(width: 120, height: 40)
                            .overlay {
                                switch viewStore.drawMode {
                                case .none: Text("트래킹")
                                case .pin: Text("-")
                                        .foregroundStyle(Color.gray)
                                case .tracking: Text("종료")
                                }
                            }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                .frame(height: 50)
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
    //                    .opacity(boxOpacity)
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
//            self.boxOpacity = 1
            self.boxBottom = 200
        }
    }
    
    private func hideBox() {
        withAnimation(.easeInOut(duration: 0.1)) {
//            self.boxOpacity = 0
            self.boxBottom = -400
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showLocation = false
        }
    }
}
