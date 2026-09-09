//
//  NavigationAndPlayViewTests.swift
//  VibeCaddyTests
//
//  Unit tests verifying Navigation and Play View redesign structures,
//  AppTab enum cases, PlayCTAPhase animation parameters, and view contracts.
//

import Testing
import SwiftUI
@testable import VibeCaddy

@MainActor
struct NavigationAndPlayViewTests {

    // MARK: - AppTab Tests

    @Test func testAppTabEnumCases() {
        let tabs = AppTab.allCases
        #expect(tabs.count == 3)
        #expect(tabs.contains(.clubs))
        #expect(tabs.contains(.play))
        #expect(tabs.contains(.leaderboard))
        
        #expect(AppTab.clubs.rawValue == "clubs")
        #expect(AppTab.play.rawValue == "play")
        #expect(AppTab.leaderboard.rawValue == "leaderboard")
    }

    // MARK: - PlayCTAPhase Animation Tests

    @Test func testPlayCTAPhaseCountAndPhases() {
        let phases = PlayCTAPhase.allCases
        #expect(phases.count == 3)
        #expect(phases[0] == .cyan)
        #expect(phases[1] == .blend)
        #expect(phases[2] == .green)
    }

    @Test func testPlayCTAPhaseColors() {
        #expect(PlayCTAPhase.cyan.accentColor == NeoFuturisticTheme.radianiteCyan)
        #expect(PlayCTAPhase.green.accentColor == NeoFuturisticTheme.cyberGreen)
        #expect(PlayCTAPhase.blend.accentColor == Color(hex: "#00F7C4"))
    }

    @Test func testPlayCTAPhaseScales() {
        #expect(PlayCTAPhase.cyan.scale == 1.0)
        #expect(PlayCTAPhase.blend.scale == 1.01)
        #expect(PlayCTAPhase.green.scale == 1.02)
    }

    @Test func testPlayCTAPhaseShadowRadii() {
        #expect(PlayCTAPhase.cyan.shadowRadius == 4.0)
        #expect(PlayCTAPhase.blend.shadowRadius == 8.0)
        #expect(PlayCTAPhase.green.shadowRadius == 12.0)
    }

    @Test func testPlayCTAPhaseGlowOpacities() {
        #expect(PlayCTAPhase.cyan.glowOpacity == 0.65)
        #expect(PlayCTAPhase.blend.glowOpacity == 0.8)
        #expect(PlayCTAPhase.green.glowOpacity == 0.95)
    }

    // MARK: - View Component Construction Tests

    @Test func testInfoCardConstruction() {
        let card = InfoCard(
            title: "WEATHER",
            value: "72°",
            icon: "sun.max.fill",
            accentColor: NeoFuturisticTheme.radianiteCyan
        )
        #expect(card.title == "WEATHER")
        #expect(card.value == "72°")
        #expect(card.icon == "sun.max.fill")
        #expect(card.accentColor == NeoFuturisticTheme.radianiteCyan)
    }

    @Test func testTabBarButtonConstruction() {
        var tapped = false
        let button = TabBarButton(
            icon: "bag.fill",
            title: "INVENTORY",
            isSelected: true,
            identifier: "tab_inventory",
            action: { tapped = true }
        )
        #expect(button.icon == "bag.fill")
        #expect(button.title == "INVENTORY")
        #expect(button.isSelected == true)
        #expect(button.identifier == "tab_inventory")
        
        button.action()
        #expect(tapped == true)
    }

    @Test func testContentViewConstruction() {
        _ = ContentView()
    }

    @Test func testMainTabViewConstruction() {
        _ = MainTabView()
    }

    @Test func testPlayViewConstruction() {
        _ = PlayView()
    }
}
