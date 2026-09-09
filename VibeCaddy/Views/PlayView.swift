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
            NeoFuturisticTheme.voidBlack
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Tactical Status Line
                    statusLine
                    
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
    
    // MARK: - Tactical Status Line
    
    private var statusLine: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(NeoFuturisticTheme.cyberGreen)
                .frame(width: 6, height: 6)
                .shadow(color: NeoFuturisticTheme.cyberGreen.opacity(0.8), radius: 3)
            
            Text("SYSTEM ONLINE // GPS.LOCK")
                .font(.hudTelemetry)
                .foregroundStyle(NeoFuturisticTheme.cyberGreen)
                .hudTracking(1.2)
            
            Spacer()
            
            Text("TELEMETRY: ACTIVE")
                .font(.hudTelemetry)
                .foregroundStyle(NeoFuturisticTheme.textMuted)
                .hudTracking(1.0)
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello \(userViewModel.profile.name)")
                    .font(.hudHeadline)
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
                    .hudTracking(0.5)
                
                Text("Ready to play?")
                    .font(.hudSubheadline)
                    .foregroundStyle(NeoFuturisticTheme.textSecondary)
                    .hudTracking(0.5)
            }
            
            Spacer()
            
            HexBadge(style: .chamfered(cutSize: 8), accentColor: NeoFuturisticTheme.radianiteCyan) {
                Image(systemName: "person.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Course Map HUD
    
    private var mapHUDSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("// GPS: 36.5688° N, 121.9472° W")
                    .font(.hudTelemetry)
                    .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    .hudTracking(1.2)
                
                Spacer()
                
                HStack(spacing: 4) {
                    TacticalCrosshair(size: 8)
                        .stroke(NeoFuturisticTheme.radianiteCyan.opacity(0.8), lineWidth: 1)
                        .frame(width: 8, height: 8)
                    Text("RADAR LOCK")
                        .font(.hudTelemetry)
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                }
            }
            .padding(.horizontal, 28)
            
            ZStack {
                Map()
                    .clipShape(ChamferedRectangle(cutSize: 14, corners: .all))
                    .frame(height: 280)
                    .overlay(
                        ChamferedRectangle(cutSize: 14, corners: .all)
                            .stroke(NeoFuturisticTheme.radianiteCyan.opacity(0.35), lineWidth: 1.5)
                            .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.2), radius: 6)
                    )
                    .overlay(
                        CornerBracketsShape(bracketLength: 16, inset: 4)
                            .stroke(NeoFuturisticTheme.radianiteCyan, lineWidth: 2)
                            .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.8), radius: 4)
                    )
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Telemetry Section
    
    private var telemetrySection: some View {
        HStack(spacing: 14) {
            InfoCard(
                title: "WEATHER",
                value: viewModel.weatherTemperature,
                icon: viewModel.weatherIcon,
                accentColor: NeoFuturisticTheme.radianiteCyan
            )
            
            InfoCard(
                title: "WIND",
                value: viewModel.windSpeed,
                icon: viewModel.windIcon,
                accentColor: NeoFuturisticTheme.cyberGreen
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
                    .font(.hudHeadline)
                    .hudTracking(1.5)
            }
            .foregroundStyle(NeoFuturisticTheme.voidBlack)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .accessibilityIdentifier("btn_start_round")
        .phaseAnimator(PlayCTAPhase.allCases) { content, phase in
            content
                .background(
                    ChamferedRectangle(cutSize: 10, corners: [.topRight, .bottomLeft])
                        .fill(phase.accentColor)
                )
                .overlay(
                    ChamferedRectangle(cutSize: 10, corners: [.topRight, .bottomLeft])
                        .stroke(phase.accentColor, lineWidth: 2)
                        .shadow(color: phase.accentColor.opacity(phase.glowOpacity), radius: phase.shadowRadius)
                )
                .scaleEffect(phase.scale)
        } animation: { _ in
            .easeInOut(duration: 1.0)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Telemetry InfoCard Component

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    var accentColor: Color = NeoFuturisticTheme.radianiteCyan
    
    var body: some View {
        FuturisticCard(
            cornerStyle: .chamfered(cutSize: 10, corners: [.topRight, .bottomLeft]),
            tint: NeoFuturisticTheme.surfaceDark.opacity(0.85),
            borderColor: accentColor.opacity(0.4),
            glowColor: accentColor.opacity(0.25),
            showBrackets: true,
            bracketLength: 8,
            contentPadding: 14
        ) {
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(accentColor)
                        .shadow(color: accentColor.opacity(0.6), radius: 4)
                    
                    Text(title)
                        .font(.hudCaption)
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                        .hudTracking(1.5)
                }
                .frame(maxWidth: .infinity)
                
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    PlayView()
        .environment(UserViewModel())
}
