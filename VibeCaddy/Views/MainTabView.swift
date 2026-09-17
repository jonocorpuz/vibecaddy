import SwiftUI

import UIKit

enum AppTab: String, CaseIterable {
    case clubs, play, leaderboard
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .play
    @Namespace private var tabNamespace
    
    init(initialTab: AppTab = .play) {
        _selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        ZStack {
            NeoFuturisticTheme.slateBackground
                .ignoresSafeArea()
            
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
        HStack(spacing: 6) {
            TabBarButton(
                icon: "bag.fill",
                title: "INVENTORY",
                isSelected: selectedTab == .clubs,
                identifier: "tab_inventory",
                namespace: tabNamespace
            ) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                    selectedTab = .clubs
                }
            }
            
            TabBarButton(
                icon: "map.fill",
                title: "PLAY",
                isSelected: selectedTab == .play,
                identifier: "tab_play",
                namespace: tabNamespace
            ) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                    selectedTab = .play
                }
            }
            
            TabBarButton(
                icon: "trophy.fill",
                title: "RANKINGS",
                isSelected: selectedTab == .leaderboard,
                identifier: "tab_rankings",
                namespace: tabNamespace
            ) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                    selectedTab = .leaderboard
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "#1E222D"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.14),
                            Color.white.opacity(0.04)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.0
                )
        )
        .shadow(color: Color.black.opacity(0.35), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 6)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var identifier: String = ""
    var namespace: Namespace.ID? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.white : Color(hex: "#6E7688"))
                
                Text(title)
                    .font(.system(size: 11, weight: .semibold, design: .default))
                    .hudTracking(0.8)
                    .foregroundStyle(isSelected ? Color.white : Color(hex: "#7E8799"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                if isSelected {
                    let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)
                    if let namespace = namespace {
                        shape
                            .fill(Color(hex: "#7A22E0").opacity(0.22))
                            .overlay(
                                shape
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: "#9F45F8").opacity(0.35),
                                                Color(hex: "#7A22E0").opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.0
                                    )
                            )
                            .matchedGeometryEffect(id: "activeTabIndicator", in: namespace)
                    } else {
                        shape
                            .fill(Color(hex: "#7A22E0").opacity(0.22))
                            .overlay(
                                shape
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: "#9F45F8").opacity(0.35),
                                                Color(hex: "#7A22E0").opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.0
                                    )
                            )
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier.isEmpty ? title.lowercased() : identifier)
    }
}

#Preview {
    MainTabView()
        .environment(UserViewModel())
        .environment(ClubsViewModel())
}
