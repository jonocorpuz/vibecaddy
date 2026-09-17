//
//  ClubDTO.swift
//  VibeCaddy
//

import Foundation

struct ClubDTO: Codable, Identifiable, Equatable, Sendable {
    var id: UUID
    var name: String
    var type: String
    var averageDistance: Double?
    var blockCategory: String?

    init(
        id: UUID = UUID(),
        name: String,
        type: String,
        averageDistance: Double? = nil,
        blockCategory: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.averageDistance = averageDistance
        self.blockCategory = blockCategory
    }

    init(from club: Club) {
        self.id = club.id
        self.name = club.name
        self.type = club.type
        self.averageDistance = club.averageDistance
        self.blockCategory = club.blockCategory
    }

    init(club: Club) {
        self.init(from: club)
    }

    func toClub() -> Club {
        Club(
            id: id,
            name: name,
            type: type,
            averageDistance: averageDistance,
            blockCategory: blockCategory
        )
    }

    static let defaultClubs: [ClubDTO] = [
        ClubDTO(name: "Taylormade M4 9.5", type: "Driver", averageDistance: 250, blockCategory: "Driver"),
        ClubDTO(name: "Callaway AI Smoke Max", type: "3w", averageDistance: 220, blockCategory: "Fairway Woodss"),
        ClubDTO(name: "Taylormade M4", type: "3h", averageDistance: 200, blockCategory: "Hybrid"),
        ClubDTO(name: "Titleist T300", type: "5i", averageDistance: 180, blockCategory: "Iron Set"),
        ClubDTO(name: "Titleist T300", type: "7i", averageDistance: 155, blockCategory: "Iron Set"),
        ClubDTO(name: "Titleist T300", type: "9i", averageDistance: 130, blockCategory: "Iron Set"),
        ClubDTO(name: "Titleist Vokey SM10", type: "GW", averageDistance: 110, blockCategory: "Wedges"),
        ClubDTO(name: "Titleist Vokey SM10", type: "SW", averageDistance: 95, blockCategory: "Wedges"),
        ClubDTO(name: "LAB DF3i", type: "Putter", averageDistance: nil, blockCategory: "Putter")
    ]
}

// MARK: - Club Bridging Extension

extension Club {
    convenience init(dto: ClubDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            type: dto.type,
            averageDistance: dto.averageDistance,
            blockCategory: dto.blockCategory
        )
    }

    var dto: ClubDTO {
        ClubDTO(from: self)
    }
}
