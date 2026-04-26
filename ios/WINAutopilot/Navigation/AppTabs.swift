import SwiftUI

enum AppTab: Hashable {
    case setup, builder, offer, validator, dashboard
}

struct AppTabs: View {
    @State private var selection: AppTab = .setup

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.08)

        let normal = UIColor.white.withAlphaComponent(0.35)
        let selected = UIColor(red: 0/255, green: 255/255, blue: 136/255, alpha: 1)

        appearance.stackedLayoutAppearance.normal.iconColor = normal
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normal]
        appearance.stackedLayoutAppearance.selected.iconColor = selected
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selection) {
            MerchantSetupScreen(switchTab: { selection = $0 })
                .tabItem { Label("Setup", systemImage: "building.2.fill") }
                .tag(AppTab.setup)

            AIPromoBuilderScreen(switchTab: { selection = $0 })
                .tabItem { Label("AI Builder", systemImage: "wand.and.stars") }
                .tag(AppTab.builder)

            PublicOfferScreen()
                .tabItem { Label("Offer", systemImage: "tag.fill") }
                .tag(AppTab.offer)

            ValidatorScreen()
                .tabItem { Label("Validator", systemImage: "qrcode.viewfinder") }
                .tag(AppTab.validator)

            DashboardScreen()
                .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }
                .tag(AppTab.dashboard)
        }
        .tint(AppColors.neonGreen)
        .background(AppColors.bgMain.ignoresSafeArea())
        .withToast()
    }
}
