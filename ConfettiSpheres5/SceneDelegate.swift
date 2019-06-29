import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let model = Model()
            window.rootViewController = UIHostingController(rootView: ContentView(model: model))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
