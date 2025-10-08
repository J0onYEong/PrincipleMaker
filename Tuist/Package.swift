// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "PrincipleMaker",
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", exact: "0.4.1"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.7.1"),
        .package(url: "https://github.com/AliSoftware/Reusable.git", exact: "4.1.2"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.8.4"),
    ]
)
