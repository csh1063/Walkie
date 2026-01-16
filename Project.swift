import ProjectDescription

let project = Project(
    name: "TakeAWalk",
    organizationName: "",
    settings: .settings(
        configurations: [
            .debug(name: "dev"),
            .release(name: "prod")
        ]),
    targets: [
        .target(
            name: "TakeAWalk",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.choi.TakeAWalk",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0.0",
                "CFBundleVersion": "1",
                "KAKAO_APP_KEY": "026c111f6ea67ef97db2bdb5ce7be07f",
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
            ]),
            sources: ["App/Sources/**"], // Sources/**누락 시 .swift 파일 수동으로 add files해야 추가됨
            resources: ["App/Resources/**"], // Sources/**누락 시 LaunchScreen.storyboard 파일 수동으로 add files해야 추가됨
            dependencies: [   
                .alamofire,
                .moya,
                .combineMoya,
                .snapKit,
                .kingfisher,
                .lottie,
                .swiftyJson,
                .kakaoMapsSDK,
                .tca
            ]
        )
    ]
)

public extension TargetDependency {
    static let alamofire: TargetDependency       = .external(name: "Alamofire")
    static let moya: TargetDependency            = .external(name: "Moya")
    static let combineMoya: TargetDependency     = .external(name: "CombineMoya")
    static let snapKit: TargetDependency         = .external(name: "SnapKit")
    static let kingfisher: TargetDependency      = .external(name: "Kingfisher")
    static let lottie: TargetDependency          = .external(name: "Lottie")
    static let swiftyJson: TargetDependency      = .external(name: "SwiftyJSON")
    static let kakaoMapsSDK: TargetDependency    = .external(name: "KakaoMapsSDK-SPM")
    static let tca: TargetDependency             = .external(name: "ComposableArchitecture")
}
