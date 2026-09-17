//
//  RoundRecord.swift
//  VibeCaddy
//

import Foundation

struct ShotRecord: Codable, Equatable, Identifiable {
    var id: UUID
    var clubName: String
    var distance: Double
    var holeNumber: Int
    var shotNumber: Int

    init(
        id: UUID = UUID(),
        clubName: String,
        distance: Double,
        holeNumber: Int = 1,
        shotNumber: Int = 1
    ) {
        self.id = id
        self.clubName = clubName
        self.distance = distance
        self.holeNumber = holeNumber
        self.shotNumber = shotNumber
    }
}

struct RoundRecord: Codable, Equatable, Identifiable {
    var id: UUID
    var date: Date
    var courseName: String
    var totalScore: Int
    var totalPar: Int
    var holesCompleted: Int
    var shots: [ShotRecord]

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        courseName: String = "Pebble Beach",
        totalScore: Int = 72,
        totalPar: Int = 72,
        holesCompleted: Int = 18,
        shots: [ShotRecord] = []
    ) {
        self.id = id
        self.date = date
        self.courseName = courseName
        self.totalScore = totalScore
        self.totalPar = totalPar
        self.holesCompleted = holesCompleted
        self.shots = shots
    }
}
