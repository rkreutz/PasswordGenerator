import UIKit
import SwiftUI
import PasswordGeneratorKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appState = AppState(from: MasterPasswordValidatorEnvironmentKey.defaultValue)

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        defer { window?.makeKeyAndVisible() }

        window?.rootViewController = RootView()
            .environmentObject(appState)
            .asHostingController()
    }
}
