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
    ]
)
