import SwiftUI

struct LeaderboardView: View {
    @Environment(UserViewModel.self) private var userViewModel
    @State private var viewModel = LeaderboardViewModel()
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 18))
                        .foregroundColor(textBeige)
                        .frame(width: 40, height: 40)
                        .background(cardDark)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(textBeige.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 30)
                .padding(.top, 16)
                
                VStack(spacing: 24) {
                        HStack {
                            Text("Overview")
                                .font(.system(.largeTitle, design: .monospaced).bold())
                                .foregroundColor(textBeige)
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        
                        // Upper Section: Handicap & Metrics
                        VStack {
                            HStack(spacing: 24) {
                                // Half Circle Chart
                                ZStack(alignment: .bottom) {
                                    Circle()
                                        .trim(from: 0.5, to: 1.0)
                                        .stroke(Color.white.opacity(0.05), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                        .frame(width: 120, height: 120)
                                    
                                    Circle()
                                        .trim(from: 0.5, to: 0.5 + (0.5 * 0.6)) // 60% progress
                                        .stroke(textBeige, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                        .frame(width: 120, height: 120)
                                    
                                    VStack(spacing: -2) {
                                        Text(String(format: "%.1f", userViewModel.profile.handicap))
                                            .font(.system(.title2, design: .monospaced).bold())
                                            .foregroundColor(textBeige)
                                        Text("HCP")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(textBeige.opacity(0.5))
                                    }
                                    .padding(.bottom, 16)
                                }
                                .frame(width: 120, height: 60, alignment: .bottom)
                                .clipped()
                                .padding(.leading, 12)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Peak HCP")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(textBeige.opacity(0.5))
                                        Text(String(format: "%.1f", viewModel.peakHandicap))
                                            .font(.system(.headline, design: .monospaced).bold())
                                            .foregroundColor(textBeige)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Last 5 Rnds")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(textBeige.opacity(0.5))
                                        Text(String(format: "%.1f", viewModel.last5RoundsHandicap))
                                            .font(.system(.headline, design: .monospaced).bold())
                                            .foregroundColor(textBeige)
                                    }
                                }
                                .padding(.trailing, 12)
                            }
                            
                            Divider()
                                .background(textBeige.opacity(0.1))
                                .padding(.vertical, 16)
                            
                            // Average Metrics
                            HStack {
                                MetricItem(title: "Birdies", value: viewModel.averageBirdies, color: textBeige, textBeige: textBeige)
                                Spacer()
                                MetricItem(title: "Pars", value: viewModel.averagePars, color: textBeige, textBeige: textBeige)
                                Spacer()
                                MetricItem(title: "Bogeys", value: viewModel.averageBogeys, color: textBeige, textBeige: textBeige)
                                Spacer()
                                MetricItem(title: "Bogey+", value: viewModel.averageDoubleBogeysPlus, color: textBeige, textBeige: textBeige)
                            }
                            .padding(.horizontal, 12)
                        }
                        .padding(24)
                        .background(cardDark)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(textBeige.opacity(0.1), lineWidth: 1))
                        .padding(.horizontal, 30)
                        
                        // Match History Container
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Text("MATCH HISTORY")
                                    .font(.system(.headline, design: .monospaced).bold())
                                    .foregroundColor(textBeige)
                                Spacer()
                                Text("View All")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(textBeige.opacity(0.5))
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 24)
                            
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 0) {
                                    ForEach(viewModel.matchHistory, id: \.id) { match in
                                        // Date Header
                                        HStack {
                                            Text(match.date.uppercased())
                                                .font(.system(.caption2, design: .monospaced).bold())
                                                .foregroundColor(textBeige.opacity(0.5))
                                            Spacer()
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.bottom, 12)
                                        .padding(.top, match.id == viewModel.matchHistory.first?.id ? 0 : 20)
                                        
                                        // Match Row
                                        HStack(spacing: 16) {
                                            // Course Info & Score
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(match.course.uppercased())
                                                    .font(.system(.subheadline, design: .monospaced).bold())
                                                    .foregroundColor(textBeige)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                
                                                HStack(spacing: 8) {
                                                    Text("\(match.score)")
                                                        .font(.system(.subheadline, design: .monospaced).bold())
                                                        .foregroundColor(textBeige)
                                                    
                                                    Text(String(format: "%+0.1f", match.hcpAffect))
                                                        .font(.system(.caption, design: .monospaced).bold())
                                                        .foregroundColor(match.hcpAffect <= 0 ? .green : .red)
                                                }
                                            }
                                            
                                            Spacer(minLength: 12)
                                            
                                            // Statlines
                                            VStack(alignment: .trailing, spacing: 2) {
                                                Text("B/P/+1/+2/DP")
                                                    .font(.system(size: 9, design: .monospaced))
                                                    .foregroundColor(textBeige.opacity(0.5))
                                                Text("\(match.birdies)/\(match.pars)/\(match.bogeys)/\(match.doubleBogeys)/\(match.doublePars)")
                                                    .font(.system(.footnote, design: .monospaced).bold())
                                                    .foregroundColor(textBeige.opacity(0.8))
                                            }
                                            
                                            // Right Accent Line
                                            Rectangle()
                                                .fill(match.hcpAffect <= 0 ? Color.green : Color.red)
                                                .frame(width: 4, height: 50)
                                                .cornerRadius(2)
                                                .padding(.leading, 8)
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.bottom, 24)
                                        
                                        if match.id != viewModel.matchHistory.last?.id {
                                            Divider().background(textBeige.opacity(0.1))
                                        }
                                    }
                                }
                            }
                        }
                        .background(cardDark)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(textBeige.opacity(0.1), lineWidth: 1))
                        .padding(.horizontal, 30)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                    // Removed ScrollView brace
            }
        }
    }
}

struct MetricItem: View {
    let title: String
    let value: String
    let color: Color
    let textBeige: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title3, design: .monospaced).bold())
                .foregroundColor(color)
            Text(title)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(textBeige.opacity(0.5))
        }
    }
}

#Preview {
    LeaderboardView()
        .environment(UserViewModel())
}
