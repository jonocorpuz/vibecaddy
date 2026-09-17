import Foundation

@Observable
final class LeaderboardViewModel {

    // MARK: - State

    var matchHistory: [MatchHistoryItem] = []

    // Aggregate stats — computed from history and persisted
    var peakHandicap: Double = 0
    var last5RoundsHandicap: Double = 0
    var averageBirdies: String = "0.0"
    var averagePars: String = "0.0"
    var averageBogeys: String = "0.0"
    var averageDoubleBogeysPlus: String = "0.0"

    private let storage: LeaderboardStorageProtocol

    // MARK: - Init

    init(storage: LeaderboardStorageProtocol = UserDefaultsStorageService.shared) {
        self.storage = storage
        loadHistory()
    }

    // MARK: - Data Loading

    /// Loads match history and stats from storage and recalculates derived values.
    func loadHistory() {
        matchHistory = storage.getMatchHistory()
        let stats = storage.getLeaderboardStats()
        peakHandicap = stats.peakHandicap
        last5RoundsHandicap = stats.last5RoundsHandicap
        averageBirdies = stats.averageBirdies
        averagePars = stats.averagePars
        averageBogeys = stats.averageBogeys
        averageDoubleBogeysPlus = stats.averageDoubleBogeysPlus
    }

    // MARK: - Mutations

    /// Adds a new match to the top of history, recalculates stats, and persists both.
    func addMatch(_ item: MatchHistoryItem) {
        matchHistory.insert(item, at: 0)
        storage.saveMatchHistory(matchHistory)
        recalculateStats()
    }

    /// Deletes a match by ID, recalculates stats, and persists.
    func deleteMatch(id: UUID) {
        matchHistory.removeAll { $0.id == id }
        storage.saveMatchHistory(matchHistory)
        recalculateStats()
    }

    // MARK: - Stats Calculation

    /// Recomputes aggregate stats from the current match history and persists them.
    func recalculateStats() {
        guard !matchHistory.isEmpty else { return }

        let count = Double(matchHistory.count)

        // Average scoring breakdown per round
        let totalBirdies = matchHistory.reduce(0) { $0 + $1.birdies }
        let totalPars = matchHistory.reduce(0) { $0 + $1.pars }
        let totalBogeys = matchHistory.reduce(0) { $0 + $1.bogeys }
        let totalDoubles = matchHistory.reduce(0) { $0 + $1.doubleBogeys + $1.doublePars }

        averageBirdies = String(format: "%.1f", Double(totalBirdies) / count)
        averagePars = String(format: "%.1f", Double(totalPars) / count)
        averageBogeys = String(format: "%.1f", Double(totalBogeys) / count)
        averageDoubleBogeysPlus = String(format: "%.1f", Double(totalDoubles) / count)

        // Peak handicap: the most favourable (lowest) hcpAffect net sum
        let runningHcp = matchHistory.map { $0.hcpAffect }.reduce(0, +)
        peakHandicap = max(0, runningHcp)

        // Last 5 rounds handicap delta
        let last5 = matchHistory.prefix(5)
        last5RoundsHandicap = last5.map { $0.hcpAffect }.reduce(0, +)

        let stats = LeaderboardStats(
            peakHandicap: peakHandicap,
            last5RoundsHandicap: last5RoundsHandicap,
            averageBirdies: averageBirdies,
            averagePars: averagePars,
            averageBogeys: averageBogeys,
            averageDoubleBogeysPlus: averageDoubleBogeysPlus
        )
        storage.saveLeaderboardStats(stats)
    }
}
