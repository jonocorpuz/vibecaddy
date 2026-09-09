//
//  ClubsAndLeaderboardViewTests.swift
//  VibeCaddyTests
//
//  Unit tests verifying ClubsView (Armory loadout, ClubBlockCard, Add/EditBlockView)
//  and LeaderboardView (Cybernetic Arc Gauge, Stat Pods, Match History combat log)
//  structures, models, and view model integration.
//

import Testing
import SwiftUI
import SwiftData
@testable import VibeCaddy

@MainActor
struct ClubsAndLeaderboardViewTests {

    // MARK: - ClubGroupKey and ClubGroup Tests

    @Test func testClubGroupKeyEqualityAndHashing() {
        let key1 = ClubGroupKey(name: "Titleist T300", category: "Iron Set")
        let key2 = ClubGroupKey(name: "Titleist T300", category: "Iron Set")
        let key3 = ClubGroupKey(name: "Taylormade M4", category: "Driver")
        
        #expect(key1 == key2)
        #expect(key1 != key3)
        #expect(key1.hashValue == key2.hashValue)
        #expect(key1.name == "Titleist T300")
        #expect(key1.category == "Iron Set")
    }

    @Test func testClubGroupInitializationAndProperties() {
        let club1 = Club(name: "Titleist T300", type: "7i", averageDistance: 155, blockCategory: "Iron Set")
        let club2 = Club(name: "Titleist T300", type: "8i", averageDistance: 145, blockCategory: "Iron Set")
        let group = ClubGroup(name: "Titleist T300", category: "Iron Set", clubs: [club1, club2])
        
        #expect(group.name == "Titleist T300")
        #expect(group.category == "Iron Set")
        #expect(group.clubs.count == 2)
        #expect(group.clubs.first?.type == "7i")
        #expect(group.id != UUID())
    }

    // MARK: - Category Styling & Helper Tests

    @Test func testCategoryAccentColors() {
        #expect(categoryAccentColor(for: "Driver") == NeoFuturisticTheme.radianiteCyan)
        #expect(categoryAccentColor(for: "Iron Set") == NeoFuturisticTheme.cyberGreen)
        #expect(categoryAccentColor(for: "Wedges") == NeoFuturisticTheme.neonViolet)
        #expect(categoryAccentColor(for: "Putter") == NeoFuturisticTheme.neonViolet)
        #expect(categoryAccentColor(for: "Hybrid") == NeoFuturisticTheme.radianiteCyan)
        #expect(categoryAccentColor(for: "Fairway Woodss") == Color(hex: "#00F7C4"))
        #expect(categoryAccentColor(for: "Unknown") == NeoFuturisticTheme.radianiteCyan)
    }

    @Test func testCategoryIcons() {
        #expect(categoryIcon(for: "Driver") == "scope")
        #expect(categoryIcon(for: "Fairway Woodss") == "target")
        #expect(categoryIcon(for: "Hybrid") == "bolt.horizontal.fill")
        #expect(categoryIcon(for: "Iron Set") == "shield.fill")
        #expect(categoryIcon(for: "Wedges") == "flag.fill")
        #expect(categoryIcon(for: "Putter") == "circle.circle.fill")
        #expect(categoryIcon(for: "Custom") == "cross.circle")
    }

    // MARK: - ClubsViewModel Grouping Logic Tests

    @Test func testClubsViewModelGroupingAndCustomOrder() {
        let vm = ClubsViewModel()
        let clubs = [
            Club(name: "Taylormade M4 9.5", type: "Driver", averageDistance: 250, blockCategory: "Driver"),
            Club(name: "Callaway AI Smoke Max", type: "3w", averageDistance: 220, blockCategory: "Fairway Woodss"),
            Club(name: "Taylormade M4", type: "3h", averageDistance: 200, blockCategory: "Hybrid"),
            Club(name: "Titleist T300", type: "7i", averageDistance: 155, blockCategory: "Iron Set"),
            Club(name: "Titleist Vokey SM10", type: "GW", averageDistance: 110, blockCategory: "Wedges"),
            Club(name: "LAB DF3i", type: "Putter", averageDistance: nil, blockCategory: "Putter")
        ]
        
        let groups = vm.groupClubs(clubs)
        #expect(groups.count == 6)
        #expect(groups[0].category == "Driver")
        #expect(groups[1].category == "Fairway Woodss")
        #expect(groups[2].category == "Hybrid")
        #expect(groups[3].category == "Iron Set")
        #expect(groups[4].category == "Wedges")
        #expect(groups[5].category == "Putter")
    }

    @Test func testClubsViewModelSortsClubsWithinGroupDescendingByDistance() {
        let vm = ClubsViewModel()
        let clubs = [
            Club(name: "Titleist T300", type: "9i", averageDistance: 130, blockCategory: "Iron Set"),
            Club(name: "Titleist T300", type: "5i", averageDistance: 180, blockCategory: "Iron Set"),
            Club(name: "Titleist T300", type: "7i", averageDistance: 155, blockCategory: "Iron Set")
        ]
        
        let groups = vm.groupClubs(clubs)
        #expect(groups.count == 1)
        let irons = groups[0].clubs
        #expect(irons.count == 3)
        #expect(irons[0].type == "5i")
        #expect(irons[1].type == "7i")
        #expect(irons[2].type == "9i")
    }

    // MARK: - View Component Construction Tests

    @Test func testClubBlockCardConstruction() {
        let clubs = [
            Club(name: "Titleist T300", type: "7i", averageDistance: 155, blockCategory: "Iron Set"),
            Club(name: "Titleist T300", type: "8i", averageDistance: 145, blockCategory: "Iron Set")
        ]
        let card = ClubBlockCard(name: "Titleist T300", category: "Iron Set", clubs: clubs)
        #expect(card.name == "Titleist T300")
        #expect(card.category == "Iron Set")
        #expect(card.clubs.count == 2)
    }

    @Test func testAddBlockViewConstructionAndCategories() {
        let vm = ClubsViewModel()
        let addView = AddBlockView(viewModel: vm)
        #expect(addView.categories.count == 6)
        #expect(addView.categories.contains("Driver"))
        #expect(addView.categories.contains("Fairway Woodss"))
        #expect(addView.categories.contains("Hybrid"))
        #expect(addView.categories.contains("Iron Set"))
        #expect(addView.categories.contains("Wedges"))
        #expect(addView.categories.contains("Putter"))
    }

    @Test func testEditBlockViewConstruction() {
        let vm = ClubsViewModel()
        let group = ClubGroup(
            name: "Titleist Vokey SM10",
            category: "Wedges",
            clubs: [
                Club(name: "Titleist Vokey SM10", type: "GW", averageDistance: 110, blockCategory: "Wedges"),
                Club(name: "Titleist Vokey SM10", type: "SW", averageDistance: 95, blockCategory: "Wedges")
            ]
        )
        let editView = EditBlockView(viewModel: vm, group: group)
        #expect(editView.originalGroup.name == "Titleist Vokey SM10")
        #expect(editView.originalGroup.category == "Wedges")
        #expect(editView.clubsForCategory.contains("GW"))
        #expect(editView.clubsForCategory.contains("SW"))
    }

    @Test func testClubsViewConstruction() {
        _ = ClubsView()
    }

    // MARK: - Leaderboard Tests

    @Test func testLeaderboardViewModelMockStats() {
        let vm = LeaderboardViewModel()
        #expect(vm.peakHandicap == 11.2)
        #expect(vm.last5RoundsHandicap == 13.1)
        #expect(vm.averageBirdies == "1.2")
        #expect(vm.averagePars == "7.4")
        #expect(vm.averageBogeys == "6.2")
        #expect(vm.averageDoubleBogeysPlus == "3.2")
        #expect(vm.matchHistory.count == 4)
        
        let firstMatch = vm.matchHistory[0]
        #expect(firstMatch.course == "Pebble Beach")
        #expect(firstMatch.score == 82)
        #expect(firstMatch.hcpAffect == -0.2)
    }

    @Test func testMetricItemConstruction() {
        let item = MetricItem(
            title: "Birdies",
            value: "1.2",
            color: NeoFuturisticTheme.cyberGreen,
            textBeige: NeoFuturisticTheme.textSecondary
        )
        #expect(item.title == "Birdies")
        #expect(item.value == "1.2")
        #expect(item.color == NeoFuturisticTheme.cyberGreen)
        #expect(item.textBeige == NeoFuturisticTheme.textSecondary)
    }

    @Test func testLeaderboardViewConstruction() {
        let userVM = UserViewModel()
        let view = LeaderboardView()
            .environment(userVM)
        _ = view
    }
}
