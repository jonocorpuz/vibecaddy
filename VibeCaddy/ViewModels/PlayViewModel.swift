import Foundation

@Observable
final class PlayViewModel {

    // MARK: - Telemetry (static display for now)

    var weatherTemperature: String = "72°"
    var weatherIcon: String = "sun.max.fill"
    var windSpeed: String = "5 MPH"
    var windIcon: String = "wind"

    // MARK: - Active Round State

    var isRoundActive: Bool = false
    var currentHoleNumber: Int = 1
    var currentPar: Int = 4
    var currentDistanceToPin: Int = 385
    var strokesThisHole: Int = 0
    var totalScore: Int = 0

    private let storage: RoundStorageProtocol & LeaderboardStorageProtocol

    // MARK: - Init

    init(storage: RoundStorageProtocol & LeaderboardStorageProtocol = UserDefaultsStorageService.shared) {
        self.storage = storage
    }

    // MARK: - Round Lifecycle

    /// Starts a new round, resetting all hole and score state.
    func startRound() {
        isRoundActive = true
        currentHoleNumber = 1
        currentPar = 4
        currentDistanceToPin = 385
        strokesThisHole = 0
        totalScore = 0
    }

    /// Records a shot on the current hole.
    func recordShot(club: String, distance: Double) {
        strokesThisHole += 1
    }

    /// Advances to the next hole, or finishes the round if on hole 18.
    func advanceHole() {
        totalScore += strokesThisHole
        if currentHoleNumber >= 18 {
            _ = finishRound()
        } else {
            currentHoleNumber += 1
            strokesThisHole = 0
            // Placeholder: distance and par would come from real course data in future
            currentDistanceToPin = Int.random(in: 120...480)
            currentPar = [3, 4, 4, 5].randomElement() ?? 4
        }
    }

    /// Finalises the round, saves a RoundRecord, and returns a MatchHistoryItem for the leaderboard.
    @discardableResult
    func finishRound() -> MatchHistoryItem? {
        guard isRoundActive else { return nil }

        isRoundActive = false

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let dateString = formatter.string(from: Date())

        // Build a simple match history item from the round
        let item = MatchHistoryItem(
            course: "Current Course",
            score: totalScore,
            date: dateString,
            hcpAffect: 0.0,
            birdies: 0,
            pars: 0,
            bogeys: 0,
            doubleBogeys: 0,
            doublePars: 0
        )

        // Persist the round record
        let record = RoundRecord(date: Date(), totalScore: totalScore, holesCompleted: currentHoleNumber)
        storage.addRound(record)

        // Persist to match history
        var history = storage.getMatchHistory()
        history.insert(item, at: 0)
        storage.saveMatchHistory(history)

        return item
    }

    /// Cancels the active round without saving.
    func cancelRound() {
        isRoundActive = false
        currentHoleNumber = 1
        strokesThisHole = 0
        totalScore = 0
    }
}
