import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            ClubsView()
                .tabItem {
                    Label("Clubs", systemImage: "bag.fill")
                }
            
            PlayView()
                .tabItem {
                    Label("Play", systemImage: "map.fill")
                }
            
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.fill")
                }
        }
        .preferredColorScheme(.dark)
        .tint(Color(red: 0.8, green: 0.95, blue: 0.9))
    }
}

#Preview {
    MainTabView()
}
