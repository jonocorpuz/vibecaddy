import SwiftUI
import MapKit
import UIKit

public enum PlayCTAPhase: CaseIterable, Sendable {
    case cyan
    case blend
    case green
    
    public var accentColor: Color {
        switch self {
        case .cyan:
            return NeoFuturisticTheme.radianiteCyan
        case .blend:
            return Color(hex: "#00F7C4")
        case .green:
            return NeoFuturisticTheme.cyberGreen
        }
    }
    
    public var scale: CGFloat {
        switch self {
        case .cyan:
            return 1.0
        case .blend:
            return 1.01
        case .green:
            return 1.02
        }
    }
    
    public var shadowRadius: CGFloat {
        switch self {
        case .cyan:
            return 4.0
        case .blend:
            return 8.0
        case .green:
            return 12.0
        }
    }
    
    public var glowOpacity: Double {
        switch self {
        case .cyan:
            return 0.65
        case .blend:
            return 0.8
        case .green:
            return 0.95
        }
    }
}

struct PlayView: View {
    @Environment(UserViewModel.self) private var userViewModel
    @State private var viewModel = PlayViewModel()
    
    var body: some View {
        ZStack {
            NeoFuturisticTheme.slateBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header with Avatar & Greeting
                    headerSection
                    
                    // Course Map HUD
                    mapHUDSection
                    
                    // Telemetry Cards: Weather & Wind
                    telemetrySection
                    
                    // CTA Button with .phaseAnimator
                    ctaSection
                    
                    Spacer(minLength: 24)
                }
                .padding(.top, 12)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello \(userViewModel.profile.name)")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundStyle(Color.white)
                
                Text("Ready to play?")
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundStyle(Color(hex: "#8F9AA9"))
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(hex: "#232836"))
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1.0)
                )
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(hex: "#00F0FF"))
                )
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Course Map HUD
    
    private var mapHUDSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Map()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .frame(height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1.0)
                    )
            }
            .accessibilityIdentifier("play_map_container")
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Telemetry Section
    
    private var telemetrySection: some View {
        HStack(spacing: 12) {
            InfoCard(
                title: "WEATHER",
                value: viewModel.weatherTemperature,
                icon: viewModel.weatherIcon,
                accentColor: Color(hex: "#00F0FF")
            )
            
            InfoCard(
                title: "WIND",
                value: viewModel.windSpeed,
                icon: viewModel.windIcon,
                accentColor: Color(hex: "#2DE2E6")
            )
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - CTA Section
    
    private var ctaSection: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            viewModel.startRound()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 15, weight: .bold))
                Text("START ROUND")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .hudTracking(1.0)
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#7A22E0"), Color(hex: "#C42582")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1.0)
            )
        }
        .accessibilityIdentifier("btn_start_round")
        .phaseAnimator(PlayCTAPhase.allCases) { content, phase in
            content
                .scaleEffect(phase == .cyan ? 1.0 : (phase == .blend ? 1.008 : 1.015))
                .shadow(
                    color: Color(hex: "#C42582").opacity(phase == .cyan ? 0.25 : (phase == .blend ? 0.35 : 0.4)),
                    radius: phase == .cyan ? 4.0 : (phase == .blend ? 5.0 : 6.0)
                )
        } animation: { _ in
            .easeInOut(duration: 1.2)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Telemetry InfoCard Component

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    var accentColor: Color = Color(hex: "#00F0FF")
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(accentColor)
                
                Text(title)
                    .font(.system(size: 11, weight: .semibold, design: .default))
                    .foregroundStyle(Color(hex: "#8F9AA9"))
                    .hudTracking(0.8)
            }
            .frame(maxWidth: .infinity)
            
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundStyle(Color.white)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: "#222634"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1.0)
        )
    }
}

#Preview {
    PlayView()
        .environment(UserViewModel())
}
