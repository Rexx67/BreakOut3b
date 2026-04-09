import UIKit

@main
@objc(BOAppDelegate)
final class BOAppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let appDefaults: [String: Any] = [
            "currentPlayer": -1,
            "noOfUsers": 0,
            "users": [],
            "diffs": [],
            "scores": [],
            "colors": []
        ]

        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
