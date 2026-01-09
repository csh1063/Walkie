
import ComposableArchitecture
import SwiftUI
import SwiftData

//@main
//struct TakeAWalkApp: App {
//    var body: some Scene {
//        WindowGroup {
//            RootView(
//                store: Store(
//                    initialState: RootFeature.State(),
//                    reducer: { RootFeature() }
//                )
//            )
//        }
//    }
//}

@main
struct TakeAWalkApp: App {

	@Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    let store = Store(
        initialState: RootFeature.State(),
        reducer: {
            RootFeature()
//                .dependency(\.courseRepository, .liveValue)
        }
    )
    
	init () {
		print("app init")
	}

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
                .ignoresSafeArea(.all)
            .onChange(of: scenePhase) { phase in    // 화면 phase
                switch phase {
                case .active:
                    print("app active")
                case .inactive:
                    print("app inactive")
                case .background:
                    print("app background")
                @unknown default:
                    print("app unknown default")
                }
            }
            .onOpenURL { url in       // 딥링크
                print("app URL: \(url)")
            }
            .onContinueUserActivity("<이름>") { userActivity in     // 푸시 등으로 앱으로 진입할 때에
                if let things = userActivity.userInfo?["something"] as? String {
                    print("app get \(things)")
                }
            }
        }
    }
}
