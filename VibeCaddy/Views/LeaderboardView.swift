import SwiftUI

// MARK: - LeaderboardView (Esports Tournament Leaderboard & Combat Log)

struct LeaderboardView: View {
    @Environment(UserViewModel.self) private var userViewModel
    @State private var viewModel = LeaderboardViewModel()
    
    var body: some View {
        ZStack {
            NeoFuturisticTheme.slateBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerSection
                        upperMetricHUD
                        matchHistoryContainer
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Overview")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(Color.white)
                    .hudTracking(0.5)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    // MARK: - Upper Metric HUD
    
    private var upperMetricHUD: some View {
        VStack(spacing: 16) {
            // Row 1: Cybernetic Arc Gauge & Stat Pods
            HStack(alignment: .center, spacing: 20) {
                // Handicap Arc Gauge
                handicapArcGauge
                
                Spacer()
                
                // Stat Pods (Peak HCP & Last 5 Rnds)
                VStack(alignment: .trailing, spacing: 10) {
                    // Peak HCP Pod
                    statPod(
                        title: "Peak HCP",
                        value: String(format: "%.1f", viewModel.peakHandicap),
                        accentColor: Color(hex: "#B37DFF")
                    )
                    
                    // Last 5 Rounds Pod
                    statPod(
                        title: "Last 5 Rnds",
                        value: String(format: "%.1f", viewModel.last5RoundsHandicap),
                        accentColor: Color(hex: "#38E1FF")
                    )
                }
            }
            
            // Subtle 1px Divider
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
                .padding(.vertical, 4)
            
            // Row 2: Average Metrics Grid
            HStack {
                MetricItem(
                    title: "Birdies",
                    value: viewModel.averageBirdies,
                    color: Color(hex: "#2CE5A5")
                )
                Spacer()
                MetricItem(
                    title: "Pars",
                    value: viewModel.averagePars,
                    color: Color(hex: "#7DD3FC")
                )
                Spacer()
                MetricItem(
                    title: "Bogeys",
                    value: viewModel.averageBogeys,
                    color: Color(hex: "#F87171")
                )
                Spacer()
                MetricItem(
                    title: "Bogey+",
                    value: viewModel.averageDoubleBogeysPlus,
                    color: Color(hex: "#EF4444")
                )
            }
            .padding(.horizontal, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: "#202430"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1.0)
        )
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
                    Color(hex: "#161922"),
                    style: StrokeStyle(lineWidth: 9, lineCap: .round)
                )
                .frame(width: 124, height: 124)
            
            // Gradient Stroke Royal Purple to Luminous Magenta (#7928CA to #FF0080)
            Circle()
                .trim(from: 0.5, to: 0.5 + (0.5 * progress))
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#7928CA"), Color(hex: "#FF0080")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 9, lineCap: .round)
                )
                .frame(width: 124, height: 124)
                .shadow(color: Color(hex: "#FF0080").opacity(0.3), radius: 4)
            
            // Center Readout
            VStack(spacing: 0) {
                Text(String(format: "%.1f", userViewModel.profile.handicap))
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(Color.white)
                
                Text("HCP")
                    .font(.system(size: 11, weight: .bold, design: .default))
                    .foregroundStyle(Color(hex: "#C42582"))
                    .hudTracking(1.2)
            }
            .padding(.bottom, 10)
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
                
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .default))
                    .foregroundStyle(Color(hex: "#8F9AA9"))
                    .hudTracking(0.5)
            }
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundStyle(accentColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(hex: "#262B3A"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1.0)
        )
    }
    
    // MARK: - Match History Combat Log Container
    
    private var matchHistoryContainer: some View {
        VStack(spacing: 0) {
            // Section Header
            HStack {
                HStack(spacing: 6) {
                    TacticalCrosshair(size: 8)
                        .stroke(Color(hex: "#00F0FF"), lineWidth: 1.2)
                        .frame(width: 8, height: 8)
                    
                    Text("MATCH HISTORY")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundStyle(Color.white)
                        .hudTracking(1.0)
                }
                
                Spacer()
                
                Text("View All")
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .foregroundStyle(Color(hex: "#00F0FF"))
                    .hudTracking(0.8)
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
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: "#202430"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1.0)
        )
        .padding(.horizontal, 24)
    }
    
    // MARK: - Match Row Component
    
    private func matchRow(match: MatchHistoryItem) -> some View {
        let isPositiveDelta = match.hcpAffect <= 0
        let deltaColor = isPositiveDelta ? Color(hex: "#2CE5A5") : Color(hex: "#EF4444")
        
        return VStack(spacing: 8) {
            // Date Header
            HStack {
                Text(match.date.uppercased())
                    .font(.system(size: 11, weight: .semibold, design: .default))
                    .foregroundStyle(Color(hex: "#7E8799"))
                    .hudTracking(0.8)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            // Match Content Row
            HStack(spacing: 14) {
                // Course Info & Score
                VStack(alignment: .leading, spacing: 4) {
                    Text(match.course.uppercased())
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    HStack(spacing: 8) {
                        Text("\(match.score)")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundStyle(Color.white)
                        
                        // Delta Pill
                        Text(String(format: "%+0.1f", match.hcpAffect))
                            .font(.system(size: 11, weight: .semibold, design: .default))
                            .foregroundStyle(deltaColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(deltaColor.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(deltaColor.opacity(0.35), lineWidth: 1.0)
                            )
                    }
                }
                
                Spacer(minLength: 12)
                
                // Statlines (B/P/+1/+2/DP)
                VStack(alignment: .trailing, spacing: 2) {
                    Text("B/P/+1/+2/DP")
                        .font(.system(size: 9, weight: .medium, design: .default))
                        .foregroundStyle(Color(hex: "#8E97A6"))
                        .hudTracking(0.8)
                    
                    Text("\(match.birdies)/\(match.pars)/\(match.bogeys)/\(match.doubleBogeys)/\(match.doublePars)")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundStyle(Color(hex: "#F8FAFC").opacity(0.9))
                }
                
                // Minimal 3px vertical accent bar without glowing shadow
                RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                    .fill(deltaColor)
                    .frame(width: 3, height: 44)
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
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundStyle(color)
            
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .default))
                .foregroundStyle(Color(hex: "#8B949E"))
                .hudTracking(0.8)
        }
    }
}

// MARK: - Preview

#Preview {
    LeaderboardView()
        .environment(UserViewModel())
}
