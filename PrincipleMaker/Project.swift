import ProjectDescription
import EnvironmentPlugin

let project = Project(
    name: "PrincipleMaker",
    targets: [
        
        // MARK: Final application module
        .target(
            name: ProjectEnvironment.serviceDisplayName,
            destinations: [.iPhone],
            product: .app,
            bundleId: ProjectEnvironment.mainAppTargetBundleId,
            deploymentTargets: ProjectEnvironment.deploymentTarget,
            infoPlist: .createApplicationPlist(with: [:]),
            buildableFolders: [
                "Sources",
                "Resources",
            ],
            dependencies: [
                .external(name: "CombineCocoa"),
                .external(name: "SnapKit"),
                .external(name: "Reusable"),
                .external(name: "Swinject"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "\(ProjectEnvironment.swiftVersion)",
                    "ENABLE_TESTABILITY": "YES",
                ]
            )
        ),
        
        // MARK: Test module
        .target(
            name: ProjectEnvironment.serviceDisplayName + "Tests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: ProjectEnvironment.mainAppTargetBundleId + ".tests",
            buildableFolders: ["Tests"],
            dependencies: [
                .target(name: ProjectEnvironment.serviceDisplayName)
            ]
        ),
    ]
)
