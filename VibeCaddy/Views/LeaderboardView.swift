import SwiftUI

// MARK: - LeaderboardView (Esports Tournament Leaderboard & Combat Log)

struct LeaderboardView: View {
    @Environment(UserViewModel.self) private var userViewModel
    @State private var viewModel = LeaderboardViewModel()
    
    var body: some View {
        ZStack {
            NeoFuturisticTheme.voidBlack
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Telemetry Status Bar & Avatar
                topStatusBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Section Header: Overview
                        headerSection
                        
                        // Upper Section: Cybernetic Arc Gauge & Telemetry Metrics
                        upperMetricHUD
                        
                        // Match History: Esports Combat Log
                        matchHistoryContainer
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    // MARK: - Top Status Bar
    
    private var topStatusBar: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(NeoFuturisticTheme.cyberGreen)
                    .frame(width: 6, height: 6)
                    .shadow(color: NeoFuturisticTheme.cyberGreen.opacity(0.8), radius: 3)
                
                Text("RANKINGS: DIVISION 1 // REGIONAL")
                    .font(.hudTelemetry)
                    .foregroundStyle(NeoFuturisticTheme.cyberGreen)
                    .hudTracking(1.2)
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
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("COMBAT LOG // TOURNAMENT RANKINGS")
                    .font(.hudTelemetry)
                    .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    .hudTracking(1.5)
                
                Text("Overview")
                    .font(.hudHeadline)
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
                    .hudTracking(0.5)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    // MARK: - Upper Metric HUD
    
    private var upperMetricHUD: some View {
        FuturisticCard(
            cornerStyle: .chamfered(cutSize: 14, corners: .all),
            tint: NeoFuturisticTheme.panelDark.opacity(0.85),
            borderColor: NeoFuturisticTheme.radianiteCyan.opacity(0.35),
            glowColor: NeoFuturisticTheme.radianiteCyan.opacity(0.2),
            showBrackets: true,
            bracketLength: 10,
            contentPadding: 20
        ) {
            VStack(spacing: 16) {
                // Row 1: Cybernetic Arc Gauge & Stat Pods
                HStack(alignment: .center, spacing: 20) {
                    // Cybernetic Arc Gauge
                    handicapArcGauge
                    
                    Spacer()
                    
                    // Stat Pods (Peak HCP & Last 5 Rnds)
                    VStack(alignment: .trailing, spacing: 12) {
                        // Peak HCP Pod
                        statPod(
                            title: "Peak HCP",
                            value: String(format: "%.1f", viewModel.peakHandicap),
                            accentColor: NeoFuturisticTheme.neonViolet
                        )
                        
                        // Last 5 Rounds Pod
                        statPod(
                            title: "Last 5 Rnds",
                            value: String(format: "%.1f", viewModel.last5RoundsHandicap),
                            accentColor: NeoFuturisticTheme.radianiteCyan
                        )
                    }
                }
                
                // Glowing Divider
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                NeoFuturisticTheme.radianiteCyan.opacity(0.4),
                                NeoFuturisticTheme.cyberGreen.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                    .padding(.vertical, 4)
                
                // Row 2: Average Metrics Grid
                HStack {
                    MetricItem(
                        title: "Birdies",
                        value: viewModel.averageBirdies,
                        color: NeoFuturisticTheme.cyberGreen,
                        textBeige: NeoFuturisticTheme.textSecondary
                    )
                    Spacer()
                    MetricItem(
                        title: "Pars",
                        value: viewModel.averagePars,
                        color: NeoFuturisticTheme.radianiteCyan,
                        textBeige: NeoFuturisticTheme.textSecondary
                    )
                    Spacer()
                    MetricItem(
                        title: "Bogeys",
                        value: viewModel.averageBogeys,
                        color: NeoFuturisticTheme.hazardRed.opacity(0.85),
                        textBeige: NeoFuturisticTheme.textSecondary
                    )
                    Spacer()
                    MetricItem(
                        title: "Bogey+",
                        value: viewModel.averageDoubleBogeysPlus,
                        color: NeoFuturisticTheme.hazardRed,
                        textBeige: NeoFuturisticTheme.textSecondary
                    )
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Handicap Arc Gauge Component
    
    private var handicapArcGauge: some View {
        let progress = min(max(userViewModel.profile.handicap / 36.0, 0.1), 1.0)
        
        return ZStack(alignment: .bottom) {
            // Background Track Arc
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(
                    NeoFuturisticTheme.surfaceElevated,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 124, height: 124)
            
            // Glowing Cybernetic Arc
            Circle()
                .trim(from: 0.5, to: 0.5 + (0.5 * progress))
                .stroke(
                    LinearGradient(
                        colors: [NeoFuturisticTheme.radianiteCyan, NeoFuturisticTheme.cyberGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 124, height: 124)
                .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.65), radius: 6)
            
            // Center Readout
            VStack(spacing: -2) {
                Text(String(format: "%.1f", userViewModel.profile.handicap))
                    .font(.system(.title2, design: .monospaced).bold())
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
                    .shadow(color: NeoFuturisticTheme.radianiteCyan.opacity(0.5), radius: 4)
                
                Text("HCP")
                    .font(.system(.caption, design: .monospaced).bold())
                    .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    .hudTracking(1.5)
            }
            .padding(.bottom, 14)
        }
        .frame(width: 124, height: 62, alignment: .bottom)
        .clipped()
    }
    
    // MARK: - Stat Pod Helper
    
    private func statPod(title: String, value: String, accentColor: Color) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 5) {
                Circle()
                    .fill(accentColor)
                    .frame(width: 5, height: 5)
                    .shadow(color: accentColor.opacity(0.8), radius: 2)
                
                Text(title)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(NeoFuturisticTheme.textSecondary)
                    .hudTracking(0.8)
            }
            
            Text(value)
                .font(.system(.headline, design: .monospaced).bold())
                .foregroundStyle(accentColor)
                .shadow(color: accentColor.opacity(0.5), radius: 4)
        }
    }
    
    // MARK: - Match History Combat Log Container
    
    private var matchHistoryContainer: some View {
        FuturisticCard(
            cornerStyle: .chamfered(cutSize: 14, corners: .all),
            tint: NeoFuturisticTheme.panelDark.opacity(0.85),
            borderColor: NeoFuturisticTheme.radianiteCyan.opacity(0.3),
            glowColor: NeoFuturisticTheme.radianiteCyan.opacity(0.15),
            showBrackets: false,
            contentPadding: 0
        ) {
            VStack(spacing: 0) {
                // Section Header
                HStack {
                    HStack(spacing: 6) {
                        TacticalCrosshair(size: 8)
                            .stroke(NeoFuturisticTheme.radianiteCyan, lineWidth: 1.5)
                            .frame(width: 8, height: 8)
                        
                        Text("MATCH HISTORY")
                            .font(.system(.headline, design: .monospaced).bold())
                            .foregroundStyle(NeoFuturisticTheme.textPrimary)
                            .hudTracking(1.2)
                    }
                    
                    Spacer()
                    
                    Text("View All")
                        .font(.system(.caption, design: .monospaced).bold())
                        .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                        .hudTracking(1.0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                // Matches Timeline
                VStack(spacing: 0) {
                    ForEach(viewModel.matchHistory, id: \.id) { match in
                        matchRow(match: match)
                        
                        if match.id != viewModel.matchHistory.last?.id {
                            Rectangle()
                                .fill(NeoFuturisticTheme.textMuted.opacity(0.2))
                                .frame(height: 1)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Match Row Component
    
    private func matchRow(match: MatchHistoryItem) -> some View {
        let isPositiveDelta = match.hcpAffect <= 0
        let deltaColor = isPositiveDelta ? NeoFuturisticTheme.cyberGreen : NeoFuturisticTheme.hazardRed
        
        return VStack(spacing: 8) {
            // Date Header
            HStack {
                Text(match.date.uppercased())
                    .font(.system(.caption2, design: .monospaced).bold())
                    .foregroundStyle(NeoFuturisticTheme.textSecondary.opacity(0.8))
                    .hudTracking(1.0)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            // Match Content Row
            HStack(spacing: 14) {
                // Course Info & Score
                VStack(alignment: .leading, spacing: 4) {
                    Text(match.course.uppercased())
                        .font(.system(.subheadline, design: .monospaced).bold())
                        .foregroundStyle(NeoFuturisticTheme.textPrimary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    HStack(spacing: 8) {
                        Text("\(match.score)")
                            .font(.system(.subheadline, design: .monospaced).bold())
                            .foregroundStyle(NeoFuturisticTheme.textPrimary)
                        
                        // Delta Pill
                        Text(String(format: "%+0.1f", match.hcpAffect))
                            .font(.system(.caption, design: .monospaced).bold())
                            .foregroundStyle(deltaColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(deltaColor.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(deltaColor.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
                
                Spacer(minLength: 12)
                
                // Statlines (B/P/+1/+2/DP)
                VStack(alignment: .trailing, spacing: 2) {
                    Text("B/P/+1/+2/DP")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                        .hudTracking(1.0)
                    
                    Text("\(match.birdies)/\(match.pars)/\(match.bogeys)/\(match.doubleBogeys)/\(match.doublePars)")
                        .font(.system(.footnote, design: .monospaced).bold())
                        .foregroundStyle(NeoFuturisticTheme.textPrimary.opacity(0.85))
                }
                
                // Vertical Neon Energy Bar
                Rectangle()
                    .fill(deltaColor)
                    .frame(width: 4, height: 48)
                    .cornerRadius(2)
                    .shadow(color: deltaColor.opacity(0.7), radius: 4)
                    .padding(.leading, 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - MetricItem Component

struct MetricItem: View {
    let title: String
    let value: String
    let color: Color
    var textBeige: Color = NeoFuturisticTheme.textSecondary
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title3, design: .monospaced).bold())
                .foregroundStyle(color)
                .shadow(color: color.opacity(0.4), radius: 3)
            
            Text(title)
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(0.8)
        }
    }
}

// MARK: - Preview

#Preview {
    LeaderboardView()
        .environment(UserViewModel())
}
