import SwiftUI
import UIKit

@main
struct MyApp: App {
    init() {
        // Standard Apple Navigation Bar & Status Bar Frosted Material Blur
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        navAppearance.shadowColor = UIColor.separator.withAlphaComponent(0.2)

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
