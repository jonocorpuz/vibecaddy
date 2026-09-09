import SwiftUI

enum AppTab {
    case clubs, play, leaderboard
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .play
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .clubs:
                    ClubsView()
                case .play:
                    PlayView()
                case .leaderboard:
                    LeaderboardView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                customNavBar
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var customNavBar: some View {
        HStack {
            Spacer()
            TabBarButton(icon: "bag.fill", title: "INVENTORY", isSelected: selectedTab == .clubs) {
                selectedTab = .clubs
            }
            Spacer()
            TabBarButton(icon: "map.fill", title: "PLAY", isSelected: selectedTab == .play) {
                selectedTab = .play
            }
            Spacer()
            TabBarButton(icon: "trophy.fill", title: "RANKINGS", isSelected: selectedTab == .leaderboard) {
                selectedTab = .leaderboard
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .background(cardDark)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(textBeige.opacity(0.15)),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 10, design: .monospaced).bold())
            }
            .foregroundColor(isSelected ? textBeige : textBeige.opacity(0.3))
        }
    }
}

#Preview {
    MainTabView()
        .environment(UserViewModel())
}
