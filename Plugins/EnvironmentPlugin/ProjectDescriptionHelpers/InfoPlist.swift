import ProjectDescription

public extension InfoPlist {
    static let mainApplication: InfoPlist = .dictionary(applicationDefault)
}

extension InfoPlist {
    public typealias InfoPlistDictionary = [String: ProjectDescription.Plist.Value]
    public static func createApplicationPlist(with: InfoPlistDictionary) -> InfoPlist {
        let merged = applicationDefault.merging(with) { _, rhs in rhs }
        return .dictionary(merged)
    }
    private static let applicationDefault: InfoPlistDictionary = [
        "NSAppTransportSecurity" : [
            "NSAllowsArbitraryLoads" : true
        ],
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                    ]
                ]
            ]
        ],
        "CFBundleShortVersionString": "\(ProjectEnvironment.serviceVersion)",
    ]
}

