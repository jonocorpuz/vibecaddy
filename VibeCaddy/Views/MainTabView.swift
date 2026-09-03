import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // Dark brown/black matching the theme
        appearance.backgroundColor = UIColor(red: 0.10, green: 0.08, blue: 0.07, alpha: 1.0)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            ClubsView()
                .tabItem {
                    Label("Inventory", systemImage: "bag.fill")
                }
            
            PlayView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            LeaderboardView()
                .tabItem {
                    Label("Rankings", systemImage: "trophy.fill")
                }
        }
        .preferredColorScheme(.dark)
        // Muted beige/gold tint for active tabs
        .tint(Color(red: 0.86, green: 0.81, blue: 0.71))
    }
}

#Preview {
    MainTabView()
}
