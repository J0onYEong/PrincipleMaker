import ProjectDescription
import EnvironmentPlugin

let project = Project(
    name: "PrincipleMaker",
    targets: [
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
            
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "\(ProjectEnvironment.swiftVersion)"
                ]
            )
        )
    ]
)
