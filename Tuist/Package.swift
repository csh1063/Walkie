// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: ["Alamofire": .framework,
                       "Moya": .framework,
                       "CombineMoya": .framework,
                       "SnapKit": .framework,
                       "Kingfisher": .framework,
                       "Lottie": .framework,
                       "SwiftyJSON": .framework,
                       "ComposableArchitecture": .framework,
                       "KakaoMapsSDK-SPM": .staticLibrary]
        ,
        baseSettings: .settings(
            configurations: [
                .debug(name: "dev"),
                .release(name: "prod")
            ])
    )
#endif

let package = Package(
    name: "TakeAWalk",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "5.15.6"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "3.2.1"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        .package(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", from: "2.12.5"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.19.1")
    ]
)
