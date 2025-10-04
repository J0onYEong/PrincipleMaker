import ProjectDescription

public enum ProjectEnvironment {
    public static let deploymentTarget: DeploymentTargets = .iOS("26.0")
    public static let serviceDisplayName: String = "PrincipleMaker"
    public static let serviceVersion: String = "0.0.0"
    public static let mainAppTargetBundleId: String = "com.choijunyeong.PrincipleMaker"
    public static let swiftVersion: Version = "6.2"
}
