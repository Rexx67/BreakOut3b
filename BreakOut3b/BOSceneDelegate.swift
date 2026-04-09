import UIKit

@objc(BOSceneDelegate)
final class BOSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window

        if let navigationController = rootViewController as? UINavigationController,
           let settingsViewController = navigationController.topViewController as? BOSettingsTableViewController {
            settingsViewController.users = []
        }
    }
}
