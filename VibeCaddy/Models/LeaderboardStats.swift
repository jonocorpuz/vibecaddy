//
//  LeaderboardStats.swift
//  VibeCaddy
//

import Foundation

struct LeaderboardStats: Codable, Equatable {
    var peakHandicap: Double
    var last5RoundsHandicap: Double
    var averageBirdies: String
    var averagePars: String
    var averageBogeys: String
    var averageDoubleBogeysPlus: String

    init(
        peakHandicap: Double = 11.2,
        last5RoundsHandicap: Double = 13.1,
        averageBirdies: String = "1.2",
        averagePars: String = "7.4",
        averageBogeys: String = "6.2",
        averageDoubleBogeysPlus: String = "3.2"
    ) {
        self.peakHandicap = peakHandicap
        self.last5RoundsHandicap = last5RoundsHandicap
        self.averageBirdies = averageBirdies
        self.averagePars = averagePars
        self.averageBogeys = averageBogeys
        self.averageDoubleBogeysPlus = averageDoubleBogeysPlus
    }

    static let `default` = LeaderboardStats()
}
