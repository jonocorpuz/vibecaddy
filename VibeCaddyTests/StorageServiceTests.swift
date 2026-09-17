//
//  StorageServiceTests.swift
//  VibeCaddyTests
//
//  Unit tests verifying StorageServiceProtocol, UserDefaultsStorageService,
//  ClubDTO, MatchHistoryItem, LeaderboardStats, RoundRecord, and backward compatibility.
//

import Testing
import Foundation
@testable import VibeCaddy

@MainActor
struct StorageServiceTests {

    private func makeIsolatedStorage(name: String = UUID().uuidString) -> (UserDefaultsStorageService, UserDefaults) {
        let defaults = UserDefaults(suiteName: "VibeCaddyTest_\(name)")!
        defaults.removePersistentDomain(forName: "VibeCaddyTest_\(name)")
        let service = UserDefaultsStorageService(defaults: defaults)
        return (service, defaults)
    }

    // MARK: - Initial Seeding Tests

    @Test func testInitialSeedingLoadsDefaults() {
        let (service, _) = makeIsolatedStorage()

        let profile = service.getProfile()
        #expect(profile.name == "Jonathan")
        #expect(profile.handicap == 12.4)

        let clubs = service.getClubs()
        #expect(clubs.count == 9)
        #expect(clubs[0].name == "Taylormade M4 9.5")
        #expect(clubs[0].type == "Driver")
        #expect(clubs[0].averageDistance == 250)

        let matches = service.getMatchHistory()
        #expect(matches.count == 4)
        #expect(matches[0].course == "Pebble Beach")
        #expect(matches[0].score == 82)
        #expect(matches[1].course == "Spyglass Hill")
        #expect(matches[2].course == "Torrey Pines")
        #expect(matches[3].course == "Bandon Dunes")

        let stats = service.getLeaderboardStats()
        #expect(stats.peakHandicap == 11.2)
        #expect(stats.last5RoundsHandicap == 13.1)
        #expect(stats.averageBirdies == "1.2")
        #expect(stats.averagePars == "7.4")

        let rounds = service.getRounds()
        #expect(rounds.isEmpty)
    }

    // MARK: - UserProfile Storage Tests

    @Test func testUserProfileSaveAndRetrieve() {
        let (service, defaults) = makeIsolatedStorage()

        let newProfile = UserProfile(name: "Tiger Woods", handicap: +4.2)
        service.saveProfile(newProfile)

        #expect(service.getProfile().name == "Tiger Woods")
        #expect(service.getProfile().handicap == +4.2)

        // Verify across a new service instance (restart simulation)
        let restartedService = UserDefaultsStorageService(defaults: defaults)
        #expect(restartedService.getProfile().name == "Tiger Woods")
        #expect(restartedService.getProfile().handicap == +4.2)
    }

    // MARK: - Club Storage & CRUD Tests

    @Test func testClubStorageCRUD() {
        let (service, _) = makeIsolatedStorage()

        let customClub = Club(name: "Titleist TSR3", type: "Driver", averageDistance: 280, blockCategory: "Driver")
        service.addClub(customClub)

        var clubs = service.getClubs()
        #expect(clubs.count == 10)
        #expect(clubs.contains(where: { $0.id == customClub.id }))

        // Update club
        let updatedClub = Club(id: customClub.id, name: "Titleist TSR3 Black", type: "Driver", averageDistance: 290, blockCategory: "Driver")
        service.updateClub(updatedClub)

        clubs = service.getClubs()
        #expect(clubs.count == 10)
        let found = clubs.first(where: { $0.id == customClub.id })
        #expect(found?.name == "Titleist TSR3 Black")
        #expect(found?.averageDistance == 290)

        // Delete club
        service.deleteClub(id: customClub.id)
        clubs = service.getClubs()
        #expect(clubs.count == 9)
        #expect(!clubs.contains(where: { $0.id == customClub.id }))
    }

    // MARK: - MatchHistory & LeaderboardStats Tests

    @Test func testMatchHistoryAddAndDelete() {
        let (service, _) = makeIsolatedStorage()

        let newMatch = MatchHistoryItem(
            course: "Augusta National",
            score: 71,
            date: "Apr 14",
            hcpAffect: -0.8,
            birdies: 4,
            pars: 11,
            bogeys: 3,
            doubleBogeys: 0,
            doublePars: 0
        )
        service.addMatch(newMatch)

        var matches = service.getMatchHistory()
        #expect(matches.count == 5)
        #expect(matches[0].course == "Augusta National") // Prepended
        #expect(matches[0].score == 71)

        service.deleteMatch(id: newMatch.id)
        matches = service.getMatchHistory()
        #expect(matches.count == 4)
        #expect(!matches.contains(where: { $0.id == newMatch.id }))
    }

    @Test func testLeaderboardStatsPersistence() {
        let (service, defaults) = makeIsolatedStorage()

        let customStats = LeaderboardStats(
            peakHandicap: 8.5,
            last5RoundsHandicap: 9.0,
            averageBirdies: "2.4",
            averagePars: "8.5",
            averageBogeys: "5.1",
            averageDoubleBogeysPlus: "2.0"
        )
        service.saveLeaderboardStats(customStats)

        let loaded = service.getLeaderboardStats()
        #expect(loaded.peakHandicap == 8.5)
        #expect(loaded.averageBirdies == "2.4")

        let restarted = UserDefaultsStorageService(defaults: defaults)
        #expect(restarted.getLeaderboardStats().peakHandicap == 8.5)
    }

    // MARK: - RoundRecord Storage Tests

    @Test func testRoundRecordAddAndRetrieve() {
        let (service, defaults) = makeIsolatedStorage()

        let shot1 = ShotRecord(clubName: "Driver", distance: 275, holeNumber: 1, shotNumber: 1)
        let shot2 = ShotRecord(clubName: "7i", distance: 155, holeNumber: 1, shotNumber: 2)
        let round = RoundRecord(
            courseName: "St Andrews",
            totalScore: 74,
            totalPar: 72,
            holesCompleted: 18,
            shots: [shot1, shot2]
        )

        service.addRound(round)

        let rounds = service.getRounds()
        #expect(rounds.count == 1)
        #expect(rounds[0].courseName == "St Andrews")
        #expect(rounds[0].shots.count == 2)
        #expect(rounds[0].shots[0].clubName == "Driver")

        let restarted = UserDefaultsStorageService(defaults: defaults)
        #expect(restarted.getRounds().count == 1)
        #expect(restarted.getRounds()[0].shots[1].distance == 155)
    }

    // MARK: - Corrupted Data Fallback & Self-Healing Tests

    @Test func testCorruptedDataGracefulFallback() {
        let (service, defaults) = makeIsolatedStorage()

        // Inject corrupted byte data into clubs and profile
        defaults.set(Data("corrupted_json_payload".utf8), forKey: UserDefaultsStorageService.Keys.clubs)
        defaults.set(Data("not_a_profile".utf8), forKey: UserDefaultsStorageService.Keys.userProfile)
        defaults.set(Data("corrupted_matches".utf8), forKey: UserDefaultsStorageService.Keys.matchHistory)
        defaults.set(Data("bad_stats".utf8), forKey: UserDefaultsStorageService.Keys.leaderboardStats)

        // Should gracefully fallback without crashing
        let clubs = service.getClubs()
        #expect(clubs.count == 9)

        let profile = service.getProfile()
        #expect(profile.name == "Jonathan")

        let matches = service.getMatchHistory()
        #expect(matches.count == 4)

        let stats = service.getLeaderboardStats()
        #expect(stats.peakHandicap == 11.2)
    }

    // MARK: - UserDataService Backward Compatibility Tests

    @Test func testUserDataServiceBackwardCompatibility() {
        let (storage, _) = makeIsolatedStorage()
        let legacyService = UserDataService(storage: storage)

        let profile = legacyService.getUserProfile()
        #expect(profile.name == "Jonathan")

        legacyService.saveUserProfile(UserProfile(name: "Legacy User", handicap: 15.0))
        #expect(storage.getProfile().name == "Legacy User")
        #expect(legacyService.getUserProfile().name == "Legacy User")
    }

    // MARK: - Reset to Defaults Tests

    @Test func testResetToDefaults() {
        let (service, _) = makeIsolatedStorage()

        service.saveProfile(UserProfile(name: "Temp User", handicap: 20.0))
        service.saveClubs([])
        service.saveMatchHistory([])
        service.addRound(RoundRecord(courseName: "Temp Course", totalScore: 100))

        #expect(service.getClubs().isEmpty)
        #expect(service.getRounds().count == 1)

        service.resetToDefaults()

        #expect(service.getProfile().name == "Jonathan")
        #expect(service.getClubs().count == 9)
        #expect(service.getMatchHistory().count == 4)
        #expect(service.getRounds().isEmpty)
    }

    // MARK: - ClubDTO Conversion Tests

    @Test func testClubDTOConversion() {
        let club = Club(name: "Callaway Paradym", type: "Driver", averageDistance: 260, blockCategory: "Driver")
        let dto = ClubDTO(from: club)

        #expect(dto.id == club.id)
        #expect(dto.name == "Callaway Paradym")
        #expect(dto.type == "Driver")
        #expect(dto.averageDistance == 260)
        #expect(dto.blockCategory == "Driver")

        let reconverted = dto.toClub()
        #expect(reconverted.id == club.id)
        #expect(reconverted.name == "Callaway Paradym")
        #expect(reconverted.type == "Driver")
        #expect(reconverted.averageDistance == 260)
        #expect(reconverted.blockCategory == "Driver")
    }
}
