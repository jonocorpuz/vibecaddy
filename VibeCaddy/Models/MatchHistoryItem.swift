//
//  MatchHistoryItem.swift
//  VibeCaddy
//

import Foundation

struct MatchHistoryItem: Identifiable, Codable, Equatable, Sendable {
    var id: UUID
    var course: String
    var score: Int
    var date: String
    var hcpAffect: Double
    var birdies: Int
    var pars: Int
    var bogeys: Int
    var doubleBogeys: Int
    var doublePars: Int
    
    init(
        id: UUID = UUID(),
        course: String,
        score: Int,
        date: String,
        hcpAffect: Double,
        birdies: Int,
        pars: Int,
        bogeys: Int,
        doubleBogeys: Int,
        doublePars: Int
    ) {
        self.id = id
        self.course = course
        self.score = score
        self.date = date
        self.hcpAffect = hcpAffect
        self.birdies = birdies
        self.pars = pars
        self.bogeys = bogeys
        self.doubleBogeys = doubleBogeys
        self.doublePars = doublePars
    }
    
    static let defaultHistory: [MatchHistoryItem] = [
        MatchHistoryItem(course: "Pebble Beach", score: 82, date: "Oct 12", hcpAffect: -0.2, birdies: 2, pars: 8, bogeys: 5, doubleBogeys: 2, doublePars: 1),
        MatchHistoryItem(course: "Spyglass Hill", score: 88, date: "Oct 5", hcpAffect: 0.4, birdies: 0, pars: 7, bogeys: 7, doubleBogeys: 3, doublePars: 1),
        MatchHistoryItem(course: "Torrey Pines", score: 85, date: "Sep 28", hcpAffect: -0.1, birdies: 1, pars: 9, bogeys: 5, doubleBogeys: 2, doublePars: 1),
        MatchHistoryItem(course: "Bandon Dunes", score: 79, date: "Sep 20", hcpAffect: -0.5, birdies: 3, pars: 10, bogeys: 4, doubleBogeys: 1, doublePars: 0)
    ]
    
    static var defaultMatches: [MatchHistoryItem] {
        defaultHistory
    }
}
