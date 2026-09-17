//
//  Milestone1ChallengeTests.swift
//  VibeCaddyTests
//
//  Empirical challenge test suite for Milestone 1 (Storage Abstraction & Local Persistence Layer).
//  Stress-tests restart simulation, CRUD operations on all domains, edge cases, and data fidelity.
//

import Testing
import Foundation
@testable import VibeCaddy

@MainActor
struct Milestone1ChallengeTests {

    private func makeIsolatedStorage(tag: String = UUID().uuidString) -> (UserDefaultsStorageService, UserDefaults, String) {
        let suiteName = "VibeCaddyChallenge_\(tag)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let service = UserDefaultsStorageService(defaults: defaults)
        return (service, defaults, suiteName)
    }

    private func cleanUpStorage(suiteName: String) {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    // MARK: - 1. Comprehensive Multi-Domain Restart Simulation (100% Data Fidelity)

    @Test func testMultiDomainRestartSimulationFullFidelity() {
        let suiteTag = "restart_fidelity_\(UUID().uuidString)"
        var (serviceOpt, defaults, suiteName): (UserDefaultsStorageService?, UserDefaults, String) = makeIsolatedStorage(tag: suiteTag)
        guard let service1 = serviceOpt else {
            Issue.record("Failed to initialize service1")
            return
        }

        // Domain 1: User Profile
        let customProfile = UserProfile(name: "Challenger Ace", handicap: 3.8)
        service1.saveProfile(customProfile)

        // Domain 2: Clubs (Custom 14-club bag)
        let customClubs: [Club] = [
            Club(name: "Ping G430 MAX", type: "Driver", averageDistance: 275, blockCategory: "Driver"),
            Club(name: "Ping G430 MAX", type: "3w", averageDistance: 235, blockCategory: "Fairway Woodss"),
            Club(name: "Ping G430", type: "3h", averageDistance: 215, blockCategory: "Hybrid"),
            Club(name: "Mizuno Pro 241", type: "4i", averageDistance: 195, blockCategory: "Iron Set"),
            Club(name: "Mizuno Pro 241", type: "5i", averageDistance: 185, blockCategory: "Iron Set"),
            Club(name: "Mizuno Pro 241", type: "6i", averageDistance: 175, blockCategory: "Iron Set"),
            Club(name: "Mizuno Pro 241", type: "7i", averageDistance: 165, blockCategory: "Iron Set"),
            Club(name: "Mizuno Pro 241", type: "8i", averageDistance: 155, blockCategory: "Iron Set"),
            Club(name: "Mizuno Pro 241", type: "9i", averageDistance: 145, blockCategory: "Iron Set"),
            Club(name: "Mizuno Pro 241", type: "PW", averageDistance: 135, blockCategory: "Iron Set"),
            Club(name: "Titleist Vokey SM9", type: "50", averageDistance: 120, blockCategory: "Wedges"),
            Club(name: "Titleist Vokey SM9", type: "54", averageDistance: 105, blockCategory: "Wedges"),
            Club(name: "Titleist Vokey SM9", type: "58", averageDistance: 90, blockCategory: "Wedges"),
            Club(name: "Scotty Cameron Newport 2", type: "Putter", averageDistance: nil, blockCategory: "Putter")
        ]
        service1.saveClubs(customClubs)

        // Domain 3: Match History (3 distinct matches)
        let match1 = MatchHistoryItem(
            course: "Cypress Point",
            score: 75,
            date: "Nov 1",
            hcpAffect: -0.4,
            birdies: 3,
            pars: 12,
            bogeys: 2,
            doubleBogeys: 1,
            doublePars: 0
        )
        let match2 = MatchHistoryItem(
            course: "Shinnecock Hills",
            score: 78,
            date: "Oct 25",
            hcpAffect: 0.1,
            birdies: 2,
            pars: 11,
            bogeys: 4,
            doubleBogeys: 1,
            doublePars: 0
        )
        let match3 = MatchHistoryItem(
            course: "Pine Valley",
            score: 73,
            date: "Oct 18",
            hcpAffect: -0.7,
            birdies: 4,
            pars: 12,
            bogeys: 1,
            doubleBogeys: 1,
            doublePars: 0
        )
        service1.saveMatchHistory([match1, match2, match3])

        // Domain 4: Leaderboard Stats
        let customStats = LeaderboardStats(
            peakHandicap: 2.9,
            last5RoundsHandicap: 3.5,
            averageBirdies: "3.2",
            averagePars: "10.4",
            averageBogeys: "3.6",
            averageDoubleBogeysPlus: "0.8"
        )
        service1.saveLeaderboardStats(customStats)

        // Domain 5: Rounds with detailed ShotRecords
        let shotA1 = ShotRecord(clubName: "Ping G430 MAX", distance: 285, holeNumber: 1, shotNumber: 1)
        let shotA2 = ShotRecord(clubName: "Titleist Vokey SM9", distance: 95, holeNumber: 1, shotNumber: 2)
        let roundA = RoundRecord(
            courseName: "Cypress Point Club",
            totalScore: 71,
            totalPar: 72,
            holesCompleted: 18,
            shots: [shotA1, shotA2]
        )
        let shotB1 = ShotRecord(clubName: "Ping G430 MAX", distance: 260, holeNumber: 1, shotNumber: 1)
        let roundB = RoundRecord(
            courseName: "Pine Valley Golf Club",
            totalScore: 74,
            totalPar: 70,
            holesCompleted: 18,
            shots: [shotB1]
        )
        service1.saveRounds([roundA, roundB])

        // Verify pre-teardown fidelity in service1
        #expect(service1.getProfile().name == "Challenger Ace")
        #expect(service1.getClubs().count == 14)
        #expect(service1.getMatchHistory().count == 3)
        #expect(service1.getLeaderboardStats().peakHandicap == 2.9)
        #expect(service1.getRounds().count == 2)

        // TEARDOWN: simulate application termination by destroying service1
        serviceOpt = nil
        #expect(serviceOpt == nil)

        // RESTART: instantiate a completely new service instance pointing to the same suite
        let service2 = UserDefaultsStorageService(defaults: defaults)

        // ASSERT 100% DATA FIDELITY ACROSS ALL 5 DOMAINS

        // 1. Profile fidelity
        let restoredProfile = service2.getProfile()
        #expect(restoredProfile.name == "Challenger Ace")
        #expect(restoredProfile.handicap == 3.8)

        // 2. Clubs fidelity
        let restoredClubs = service2.getClubs()
        #expect(restoredClubs.count == 14)
        for (i, originalClub) in customClubs.enumerated() {
            #expect(restoredClubs[i].id == originalClub.id)
            #expect(restoredClubs[i].name == originalClub.name)
            #expect(restoredClubs[i].type == originalClub.type)
            #expect(restoredClubs[i].averageDistance == originalClub.averageDistance)
            #expect(restoredClubs[i].blockCategory == originalClub.blockCategory)
        }

        // 3. Match History fidelity
        let restoredMatches = service2.getMatchHistory()
        #expect(restoredMatches.count == 3)
        #expect(restoredMatches[0].id == match1.id)
        #expect(restoredMatches[0].course == "Cypress Point")
        #expect(restoredMatches[0].score == 75)
        #expect(restoredMatches[0].hcpAffect == -0.4)
        #expect(restoredMatches[0].birdies == 3)
        #expect(restoredMatches[1].id == match2.id)
        #expect(restoredMatches[1].course == "Shinnecock Hills")
        #expect(restoredMatches[1].score == 78)
        #expect(restoredMatches[2].id == match3.id)
        #expect(restoredMatches[2].course == "Pine Valley")

        // 4. Leaderboard Stats fidelity
        let restoredStats = service2.getLeaderboardStats()
        #expect(restoredStats.peakHandicap == 2.9)
        #expect(restoredStats.last5RoundsHandicap == 3.5)
        #expect(restoredStats.averageBirdies == "3.2")
        #expect(restoredStats.averagePars == "10.4")
        #expect(restoredStats.averageBogeys == "3.6")
        #expect(restoredStats.averageDoubleBogeysPlus == "0.8")

        // 5. Rounds fidelity
        let restoredRounds = service2.getRounds()
        #expect(restoredRounds.count == 2)
        #expect(restoredRounds[0].id == roundA.id)
        #expect(restoredRounds[0].courseName == "Cypress Point Club")
        #expect(restoredRounds[0].totalScore == 71)
        #expect(restoredRounds[0].shots.count == 2)
        #expect(restoredRounds[0].shots[0].clubName == "Ping G430 MAX")
        #expect(restoredRounds[0].shots[0].distance == 285)
        #expect(restoredRounds[0].shots[1].clubName == "Titleist Vokey SM9")
        #expect(restoredRounds[0].shots[1].distance == 95)
        #expect(restoredRounds[1].id == roundB.id)
        #expect(restoredRounds[1].shots.count == 1)

        cleanUpStorage(suiteName: suiteName)
    }

    // MARK: - 2. CRUD Operations on All Domains

    @Test func testClubsDomainFullCRUD() {
        let (service, defaults, suiteName) = makeIsolatedStorage()

        // 1. Initial State has 9 seeded clubs
        let initialClubs = service.getClubs()
        #expect(initialClubs.count == 9)

        // 2. CREATE: Add new club
        let customClub = Club(name: "Callaway Elyte 3W", type: "3w", averageDistance: 230, blockCategory: "Fairway Woodss")
        service.addClub(customClub)

        var clubs = service.getClubs()
        #expect(clubs.count == 10)
        #expect(clubs.contains(where: { $0.id == customClub.id }))
        #expect(clubs.first(where: { $0.id == customClub.id })?.averageDistance == 230)

        // 3. READ: Verify persistence across fresh reader
        let freshService = UserDefaultsStorageService(defaults: defaults)
        #expect(freshService.getClubs().count == 10)

        // 4. UPDATE: Modify existing club's properties
        let modifiedClub = Club(
            id: customClub.id,
            name: "Callaway Elyte 3W Tuned",
            type: "3w",
            averageDistance: 242,
            blockCategory: "Fairway Woodss"
        )
        service.updateClub(modifiedClub)

        clubs = service.getClubs()
        #expect(clubs.count == 10)
        let updatedFound = clubs.first(where: { $0.id == customClub.id })
        #expect(updatedFound != nil)
        #expect(updatedFound?.name == "Callaway Elyte 3W Tuned")
        #expect(updatedFound?.averageDistance == 242)

        // 5. UPDATE: Attempting to update non-existing club appends it safely
        let brandNewClub = Club(name: "Titleist TSR4", type: "Driver", averageDistance: 295, blockCategory: "Driver")
        service.updateClub(brandNewClub)
        #expect(service.getClubs().count == 11)
        #expect(service.getClubs().contains(where: { $0.id == brandNewClub.id }))

        // 6. DELETE: Delete custom club by ID
        service.deleteClub(id: customClub.id)
        clubs = service.getClubs()
        #expect(clubs.count == 10)
        #expect(!clubs.contains(where: { $0.id == customClub.id }))

        // 7. DELETE: Delete second club
        service.deleteClub(id: brandNewClub.id)
        #expect(service.getClubs().count == 9)

        // 8. DELETE: Delete non-existent ID does not crash or alter count
        service.deleteClub(id: UUID())
        #expect(service.getClubs().count == 9)

        cleanUpStorage(suiteName: suiteName)
    }

    @Test func testMatchesDomainFullCRUD() {
        let (service, defaults, suiteName) = makeIsolatedStorage()

        // 1. Initial State has 4 seeded matches
        let initialMatches = service.getMatchHistory()
        #expect(initialMatches.count == 4)

        // 2. CREATE: Add match 1 (prepends to top)
        let match1 = MatchHistoryItem(
            course: "Bethpage Black",
            score: 76,
            date: "Jul 4",
            hcpAffect: -0.3,
            birdies: 3,
            pars: 11,
            bogeys: 4,
            doubleBogeys: 0,
            doublePars: 0
        )
        service.addMatch(match1)

        var matches = service.getMatchHistory()
        #expect(matches.count == 5)
        #expect(matches[0].id == match1.id)
        #expect(matches[0].course == "Bethpage Black")

        // 3. CREATE: Add match 2 (prepends in front of match 1)
        let match2 = MatchHistoryItem(
            course: "Oakmont CC",
            score: 80,
            date: "Jul 11",
            hcpAffect: 0.2,
            birdies: 1,
            pars: 10,
            bogeys: 6,
            doubleBogeys: 1,
            doublePars: 0
        )
        service.addMatch(match2)

        matches = service.getMatchHistory()
        #expect(matches.count == 6)
        #expect(matches[0].id == match2.id)
        #expect(matches[1].id == match1.id)

        // 4. Persistence verification across new instance
        let reader = UserDefaultsStorageService(defaults: defaults)
        #expect(reader.getMatchHistory().count == 6)
        #expect(reader.getMatchHistory()[0].id == match2.id)

        // 5. DELETE: Delete match 1
        service.deleteMatch(id: match1.id)
        matches = service.getMatchHistory()
        #expect(matches.count == 5)
        #expect(!matches.contains(where: { $0.id == match1.id }))
        #expect(matches[0].id == match2.id)

        // 6. DELETE: Delete non-existent ID
        service.deleteMatch(id: UUID())
        #expect(service.getMatchHistory().count == 5)

        // 7. DELETE: Delete match 2
        service.deleteMatch(id: match2.id)
        #expect(service.getMatchHistory().count == 4)

        cleanUpStorage(suiteName: suiteName)
    }

    @Test func testRoundsDomainFullCRUD() {
        let (service, defaults, suiteName) = makeIsolatedStorage()

        // 1. Initial State: 0 rounds
        #expect(service.getRounds().isEmpty)

        // 2. CREATE: Add round 1
        let round1 = RoundRecord(
            courseName: "Whistling Straits",
            totalScore: 75,
            totalPar: 72,
            holesCompleted: 18,
            shots: [
                ShotRecord(clubName: "Driver", distance: 290, holeNumber: 1, shotNumber: 1),
                ShotRecord(clubName: "PW", distance: 130, holeNumber: 1, shotNumber: 2)
            ]
        )
        service.addRound(round1)

        var rounds = service.getRounds()
        #expect(rounds.count == 1)
        #expect(rounds[0].id == round1.id)
        #expect(rounds[0].courseName == "Whistling Straits")
        #expect(rounds[0].shots.count == 2)

        // 3. CREATE: Add round 2 (prepended)
        let round2 = RoundRecord(
            courseName: "Kiawah Island (Ocean Course)",
            totalScore: 78,
            totalPar: 72,
            holesCompleted: 18,
            shots: []
        )
        service.addRound(round2)

        rounds = service.getRounds()
        #expect(rounds.count == 2)
        #expect(rounds[0].id == round2.id)
        #expect(rounds[1].id == round1.id)

        // 4. OVERWRITE: saveRounds directly
        let round3 = RoundRecord(courseName: "Chambers Bay", totalScore: 73)
        service.saveRounds([round3])

        rounds = service.getRounds()
        #expect(rounds.count == 1)
        #expect(rounds[0].courseName == "Chambers Bay")

        // 5. Restart verification
        let reader = UserDefaultsStorageService(defaults: defaults)
        #expect(reader.getRounds().count == 1)
        #expect(reader.getRounds()[0].id == round3.id)

        cleanUpStorage(suiteName: suiteName)
    }

    // MARK: - 3. Adversarial / Edge Cases

    @Test func testEmptyCollectionsPreservedAcrossRestart() {
        // Stress test: If a user empties clubs or matches, restart should NOT resurrect defaults
        let (service1, defaults, suiteName) = makeIsolatedStorage()

        // Save empty clubs and empty matches
        service1.saveClubs([])
        service1.saveMatchHistory([])

        #expect(service1.getClubs().isEmpty)
        #expect(service1.getMatchHistory().isEmpty)

        // Instantiate new service instance on same defaults
        let service2 = UserDefaultsStorageService(defaults: defaults)

        // Verify empty arrays are strictly honored, not re-seeded
        #expect(service2.getClubs().isEmpty)
        #expect(service2.getMatchHistory().isEmpty)

        cleanUpStorage(suiteName: suiteName)
    }

    @Test func testCorruptedDomainIsolation() {
        // Stress test: If matchHistory key is corrupted, profile and clubs must remain intact
        let (service, defaults, suiteName) = makeIsolatedStorage()

        let customProfile = UserProfile(name: "Survivor", handicap: 7.2)
        service.saveProfile(customProfile)

        // Corrupt only matchHistory
        defaults.set(Data("corrupt_binary_data".utf8), forKey: UserDefaultsStorageService.Keys.matchHistory)

        // Match history should recover defaults gracefully without crashing
        let matches = service.getMatchHistory()
        #expect(matches.count == 4)

        // Uncorrupted profile must retain exact saved data
        let profile = service.getProfile()
        #expect(profile.name == "Survivor")
        #expect(profile.handicap == 7.2)

        cleanUpStorage(suiteName: suiteName)
    }

    @Test func testProfilePartialMutationsAndBoundaryHandicap() {
        let (service, defaults, suiteName) = makeIsolatedStorage()

        // Test plus handicap (scratch / better than scratch)
        let scratchProfile = UserProfile(name: "Scratch Golfer", handicap: -2.5)
        service.saveProfile(scratchProfile)
        #expect(service.getProfile().handicap == -2.5)

        // Test high handicap
        let highHcp = UserProfile(name: "Beginner", handicap: 54.0)
        service.saveProfile(highHcp)
        #expect(service.getProfile().handicap == 54.0)

        // Restart verification
        let reader = UserDefaultsStorageService(defaults: defaults)
        #expect(reader.getProfile().name == "Beginner")
        #expect(reader.getProfile().handicap == 54.0)

        cleanUpStorage(suiteName: suiteName)
    }
}
