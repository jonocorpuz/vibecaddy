//
//  StorageServiceProtocol.swift
//  VibeCaddy
//

import Foundation

// MARK: - UserProfileStorageProtocol

/// Persistence contract for user profile information
protocol UserProfileStorageProtocol: AnyObject {
    /// Retrieves the persisted user profile, or returns the default profile if none exists
    func getProfile() -> UserProfile
    
    /// Persists an updated user profile
    func saveProfile(_ profile: UserProfile)
}

// MARK: - ClubStorageProtocol

/// Persistence contract for club bag loadouts
protocol ClubStorageProtocol: AnyObject {
    /// Retrieves all saved clubs, returning seeded defaults if none exist
    func getClubs() -> [Club]
    
    /// Persists the full array of clubs
    func saveClubs(_ clubs: [Club])
    
    /// Adds a single club to storage
    func addClub(_ club: Club)
    
    /// Updates an existing club in storage (matched by id)
    func updateClub(_ club: Club)
    
    /// Deletes a club by its UUID
    func deleteClub(id: UUID)
}

// MARK: - ClubStorageProtocol Default Implementations

extension ClubStorageProtocol {
    func addClub(_ club: Club) {
        var clubs = getClubs()
        clubs.append(club)
        saveClubs(clubs)
    }
    
    func updateClub(_ club: Club) {
        var clubs = getClubs()
        if let index = clubs.firstIndex(where: { $0.id == club.id }) {
            clubs[index] = club
            saveClubs(clubs)
        }
    }
    
    func deleteClub(id: UUID) {
        var clubs = getClubs()
        clubs.removeAll { $0.id == id }
        saveClubs(clubs)
    }
}

// MARK: - LeaderboardStorageProtocol

/// Persistence contract for combat log match history and leaderboard statistics
protocol LeaderboardStorageProtocol: AnyObject {
    /// Retrieves all match history records, returning seeded items if none exist
    func getMatchHistory() -> [MatchHistoryItem]
    
    /// Persists the full array of match history items
    func saveMatchHistory(_ matches: [MatchHistoryItem])
    
    /// Prepends a new match record to the front of history
    func addMatch(_ match: MatchHistoryItem)
    
    /// Deletes a match record by its UUID
    func deleteMatch(id: UUID)
    
    /// Retrieves aggregate leaderboard statistics
    func getLeaderboardStats() -> LeaderboardStats
    
    /// Persists updated aggregate leaderboard statistics
    func saveLeaderboardStats(_ stats: LeaderboardStats)
}

// MARK: - LeaderboardStorageProtocol Default Implementations

extension LeaderboardStorageProtocol {
    func addMatch(_ match: MatchHistoryItem) {
        var matches = getMatchHistory()
        matches.insert(match, at: 0)
        saveMatchHistory(matches)
    }
    
    func deleteMatch(id: UUID) {
        var matches = getMatchHistory()
        matches.removeAll { $0.id == id }
        saveMatchHistory(matches)
    }
}

// MARK: - RoundStorageProtocol

/// Persistence contract for active and completed round records
protocol RoundStorageProtocol: AnyObject {
    /// Retrieves all completed round records
    func getRounds() -> [RoundRecord]
    
    /// Persists the full array of round records
    func saveRounds(_ rounds: [RoundRecord])
    
    /// Appends a new completed round record
    func addRound(_ round: RoundRecord)
}

// MARK: - RoundStorageProtocol Default Implementations

extension RoundStorageProtocol {
    func addRound(_ round: RoundRecord) {
        var rounds = getRounds()
        rounds.insert(round, at: 0)
        saveRounds(rounds)
    }
}

// MARK: - Unified StorageServiceProtocol

/// Master persistence protocol combining all domain storage interfaces
protocol StorageServiceProtocol: AnyObject,
    UserProfileStorageProtocol,
    ClubStorageProtocol,
    LeaderboardStorageProtocol,
    RoundStorageProtocol {
    
    /// Resets all persistence domains to default factory seeded state
    func resetToDefaults()
}
