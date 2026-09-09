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
            NeoFuturisticTheme.voidBlack
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
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
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
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
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
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    selectedTab = .leaderboard
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(NeoFuturisticTheme.panelDark.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            NeoFuturisticTheme.radianiteCyan.opacity(0.6),
                            NeoFuturisticTheme.cyberGreen.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.0
                )
                .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.3), radius: 8)
        )
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
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(isSelected ? NeoFuturisticTheme.radianiteCyan : NeoFuturisticTheme.textSecondary)
                    .shadow(
                        color: isSelected ? NeoFuturisticTheme.radianiteCyan.opacity(0.85) : .clear,
                        radius: 8
                    )
                
                Text(title)
                    .font(.system(size: 11, weight: .heavy, design: .monospaced))
                    .hudTracking(1.2)
                    .foregroundStyle(isSelected ? NeoFuturisticTheme.textPrimary : NeoFuturisticTheme.textSecondary.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                if isSelected {
                    if let namespace = namespace {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(NeoFuturisticTheme.radianiteCyan.opacity(0.18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [NeoFuturisticTheme.radianiteCyan, NeoFuturisticTheme.cyberGreen],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1.5
                                    )
                                    .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.6), radius: 6)
                            )
                            .matchedGeometryEffect(id: "activeTabIndicator", in: namespace)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(NeoFuturisticTheme.radianiteCyan.opacity(0.18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [NeoFuturisticTheme.radianiteCyan, NeoFuturisticTheme.cyberGreen],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1.5
                                    )
                                    .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.6), radius: 6)
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
}
