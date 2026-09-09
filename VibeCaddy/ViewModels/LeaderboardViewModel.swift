import Foundation
import SwiftUI

struct MatchHistoryItem: Identifiable {
    let id = UUID()
    let course: String
    let score: Int
    let date: String
    let hcpAffect: Double
    let birdies: Int
    let pars: Int
    let bogeys: Int
    let doubleBogeys: Int
    let doublePars: Int
}

@Observable
final class LeaderboardViewModel {
    var matchHistory: [MatchHistoryItem] = []
    var peakHandicap: Double = 11.2
    var last5RoundsHandicap: Double = 13.1
    
    // Averages
    var averageBirdies: String = "1.2"
    var averagePars: String = "7.4"
    var averageBogeys: String = "6.2"
    var averageDoubleBogeysPlus: String = "3.2"
    
    init() {
        loadMockHistory()
    }
    
    private func loadMockHistory() {
        matchHistory = [
            MatchHistoryItem(course: "Pebble Beach", score: 82, date: "Oct 12", hcpAffect: -0.2, birdies: 2, pars: 8, bogeys: 5, doubleBogeys: 2, doublePars: 1),
            MatchHistoryItem(course: "Spyglass Hill", score: 88, date: "Oct 5", hcpAffect: 0.4, birdies: 0, pars: 7, bogeys: 7, doubleBogeys: 3, doublePars: 1),
            MatchHistoryItem(course: "Torrey Pines", score: 85, date: "Sep 28", hcpAffect: -0.1, birdies: 1, pars: 9, bogeys: 5, doubleBogeys: 2, doublePars: 1),
            MatchHistoryItem(course: "Bandon Dunes", score: 79, date: "Sep 20", hcpAffect: -0.5, birdies: 3, pars: 10, bogeys: 4, doubleBogeys: 1, doublePars: 0)
        ]
    }
}
