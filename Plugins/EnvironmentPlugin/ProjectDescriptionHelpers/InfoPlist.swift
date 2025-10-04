import ProjectDescription

extension InfoPlist {
    public typealias InfoPlistDictionary = [String: ProjectDescription.Plist.Value]
    public static func createApplicationPlist(with: InfoPlistDictionary) -> InfoPlist {
        let merged = applicationDefaultPlist.merging(with) { _, rhs in rhs }
        return .extendingDefault(with: merged)
    }
    private static let applicationDefaultPlist: InfoPlistDictionary = [
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
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                    ]
                ]
            ]
        ],
        "CFBundleShortVersionString": "\(ProjectEnvironment.serviceVersion)",
    ]
}

