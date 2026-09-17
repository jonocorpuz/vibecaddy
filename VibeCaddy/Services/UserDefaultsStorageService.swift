//
//  UserDefaultsStorageService.swift
//  VibeCaddy
//

import Foundation

final class UserDefaultsStorageService: StorageServiceProtocol {
    static let shared = UserDefaultsStorageService()

    private let defaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    enum Keys {
        static let userProfile = "vibeCaddyUserProfile"
        static let clubs = "vibeCaddyClubs"
        static let matchHistory = "vibeCaddyMatchHistory"
        static let leaderboardStats = "vibeCaddyLeaderboardStats"
        static let rounds = "vibeCaddyRounds"
        static let hasInitialized = "vibeCaddyHasInitializedDefaults"
    }

    static let defaultProfile = UserProfile(name: "Jonathan", handicap: 12.4)

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        seedInitialDataIfNeeded()
    }

    func seedInitialDataIfNeeded() {
        if defaults.data(forKey: Keys.userProfile) == nil {
            saveProfile(Self.defaultProfile)
        }
        if defaults.data(forKey: Keys.clubs) == nil {
            saveClubsDTO(ClubDTO.defaultClubs)
        }
        if defaults.data(forKey: Keys.matchHistory) == nil {
            saveMatchHistory(MatchHistoryItem.defaultMatches)
        }
        if defaults.data(forKey: Keys.leaderboardStats) == nil {
            saveLeaderboardStats(LeaderboardStats.default)
        }
    }

    func resetToDefaults() {
        saveProfile(Self.defaultProfile)
        saveClubsDTO(ClubDTO.defaultClubs)
        saveMatchHistory(MatchHistoryItem.defaultMatches)
        saveLeaderboardStats(LeaderboardStats.default)
        saveRounds([])
    }

    // MARK: - UserProfileStorageProtocol

    func getProfile() -> UserProfile {
        if let data = defaults.data(forKey: Keys.userProfile),
           let profile = try? decoder.decode(UserProfile.self, from: data) {
            return profile
        }
        let fallback = Self.defaultProfile
        saveProfile(fallback)
        return fallback
    }

    func saveProfile(_ profile: UserProfile) {
        if let data = try? encoder.encode(profile) {
            defaults.set(data, forKey: Keys.userProfile)
        }
    }

    // MARK: - ClubStorageProtocol

    func getClubs() -> [Club] {
        return getClubsDTO().map { $0.toClub() }
    }

    func saveClubs(_ clubs: [Club]) {
        saveClubsDTO(clubs.map { ClubDTO(from: $0) })
    }

    func getClubsDTO() -> [ClubDTO] {
        if let data = defaults.data(forKey: Keys.clubs),
           let dtos = try? decoder.decode([ClubDTO].self, from: data) {
            return dtos
        }
        let fallback = ClubDTO.defaultClubs
        saveClubsDTO(fallback)
        return fallback
    }

    func saveClubsDTO(_ dtos: [ClubDTO]) {
        if let data = try? encoder.encode(dtos) {
            defaults.set(data, forKey: Keys.clubs)
        }
    }

    func addClub(_ club: Club) {
        var current = getClubs()
        current.append(club)
        saveClubs(current)
    }

    func updateClub(_ club: Club) {
        var current = getClubs()
        if let index = current.firstIndex(where: { $0.id == club.id }) {
            current[index] = club
        } else {
            current.append(club)
        }
        saveClubs(current)
    }

    func deleteClub(id: UUID) {
        var current = getClubs()
        current.removeAll(where: { $0.id == id })
        saveClubs(current)
    }

    // MARK: - LeaderboardStorageProtocol

    func getMatchHistory() -> [MatchHistoryItem] {
        if let data = defaults.data(forKey: Keys.matchHistory),
           let history = try? decoder.decode([MatchHistoryItem].self, from: data) {
            return history
        }
        let fallback = MatchHistoryItem.defaultMatches
        saveMatchHistory(fallback)
        return fallback
    }

    func saveMatchHistory(_ matches: [MatchHistoryItem]) {
        if let data = try? encoder.encode(matches) {
            defaults.set(data, forKey: Keys.matchHistory)
        }
    }

    func addMatch(_ item: MatchHistoryItem) {
        var current = getMatchHistory()
        current.insert(item, at: 0)
        saveMatchHistory(current)
    }

    func deleteMatch(id: UUID) {
        var current = getMatchHistory()
        current.removeAll(where: { $0.id == id })
        saveMatchHistory(current)
    }

    func getLeaderboardStats() -> LeaderboardStats {
        if let data = defaults.data(forKey: Keys.leaderboardStats),
           let stats = try? decoder.decode(LeaderboardStats.self, from: data) {
            return stats
        }
        let fallback = LeaderboardStats.default
        saveLeaderboardStats(fallback)
        return fallback
    }

    func saveLeaderboardStats(_ stats: LeaderboardStats) {
        if let data = try? encoder.encode(stats) {
            defaults.set(data, forKey: Keys.leaderboardStats)
        }
    }

    // MARK: - RoundStorageProtocol

    func getRounds() -> [RoundRecord] {
        if let data = defaults.data(forKey: Keys.rounds),
           let rounds = try? decoder.decode([RoundRecord].self, from: data) {
            return rounds
        }
        return []
    }

    func saveRounds(_ rounds: [RoundRecord]) {
        if let data = try? encoder.encode(rounds) {
            defaults.set(data, forKey: Keys.rounds)
        }
    }

    func addRound(_ round: RoundRecord) {
        var current = getRounds()
        current.insert(round, at: 0)
        saveRounds(current)
    }
}

// MARK: - Backward Compatibility with UserDataServiceProtocol

extension UserDefaultsStorageService: UserDataServiceProtocol {
    func getUserProfile() -> UserProfile {
        return getProfile()
    }

    func saveUserProfile(_ profile: UserProfile) {
        saveProfile(profile)
    }
}
