//
//  VibeCaddyElementVerificationUITests.swift
//  VibeCaddyUITests
//
//  Element verification suite for neo-futuristic redesigned views
//

import XCTest

final class VibeCaddyElementVerificationUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Play Screen & Navigation Elements

    @MainActor
    func testPlayViewElementsAndMainNavigationTabs() throws {
        // 1. Verify Main Navigation Tabs
        let inventoryTab = app.buttons["tab_inventory"]
        let playTab = app.buttons["tab_play"]
        let rankingsTab = app.buttons["tab_rankings"]

        XCTAssertTrue(playTab.waitForExistence(timeout: 5), "Play tab button should exist")
        XCTAssertTrue(inventoryTab.exists, "Inventory tab button should exist")
        XCTAssertTrue(rankingsTab.exists, "Rankings tab button should exist")

        // Also verify tabs by text labels
        XCTAssertTrue(app.buttons["PLAY"].exists || app.staticTexts["PLAY"].exists)
        XCTAssertTrue(app.buttons["INVENTORY"].exists || app.staticTexts["INVENTORY"].exists)
        XCTAssertTrue(app.buttons["RANKINGS"].exists || app.staticTexts["RANKINGS"].exists)

        // 2. Verify PlayView Header Greeting & Subtitle
        let greetingPredicate = NSPredicate(format: "label BEGINSWITH 'Hello'")
        let greetingLabel = app.staticTexts.matching(greetingPredicate).firstMatch
        XCTAssertTrue(greetingLabel.waitForExistence(timeout: 5), "Greeting starting with 'Hello' should exist")
        XCTAssertTrue(app.staticTexts["Ready to play?"].exists, "'Ready to play?' subheadline should exist")

        // 3. Verify Map Container
        let mapContainer = app.otherElements["play_map_container"]
        XCTAssertTrue(mapContainer.exists || app.maps.firstMatch.exists, "Course radar map container should exist")

        // 4. Verify Telemetry HUD Cards (WEATHER & WIND)
        XCTAssertTrue(app.staticTexts["WEATHER"].exists, "'WEATHER' telemetry card should exist")
        XCTAssertTrue(app.staticTexts["WIND"].exists, "'WIND' telemetry card should exist")

        // 5. Verify Call-to-Action Start Round Button
        let startRoundBtn = app.buttons["btn_start_round"]
        let startRoundLabel = app.buttons["START ROUND"]
        XCTAssertTrue(startRoundBtn.exists || startRoundLabel.exists, "'START ROUND' button should exist")
    }

    // MARK: - Armory Inventory & Add Block Flow

    @MainActor
    func testClubsViewElementsAndAddBlockFlow() throws {
        // Navigate to INVENTORY tab
        let inventoryTab = app.buttons["tab_inventory"]
        if inventoryTab.exists {
            inventoryTab.tap()
        } else {
            app.buttons["INVENTORY"].tap()
        }

        // Verify Inventory header
        XCTAssertTrue(app.staticTexts["Inventory"].waitForExistence(timeout: 5), "'Inventory' headline should exist")
        XCTAssertTrue(app.staticTexts["ARMORY // LOADOUT"].exists, "'ARMORY // LOADOUT' telemetry tag should exist")

        // Verify '+' button to add club block
        let addClubBtn = app.buttons["btn_add_club"]
        XCTAssertTrue(addClubBtn.waitForExistence(timeout: 5), "Add club block button should exist")

        // Verify presence of club blocks or loadout section
        let driverText = app.staticTexts["Driver"]
        let t300Text = app.staticTexts["Titleist T300"]
        let ironSetText = app.staticTexts["Iron Set"]
        let placeholder = app.staticTexts["NO LOADOUT BLOCKS REGISTERED"]
        XCTAssertTrue(driverText.exists || t300Text.exists || ironSetText.exists || placeholder.exists, "Club blocks or empty loadout card should exist")

        // Open AddBlock navigation / sheet
        addClubBtn.tap()

        // Verify AddBlock View elements
        XCTAssertTrue(app.staticTexts["New Block"].waitForExistence(timeout: 5), "'New Block' title should exist")
        XCTAssertTrue(app.staticTexts["Block Type"].exists, "'Block Type' section header should exist")

        // Verify category chips
        XCTAssertTrue(app.buttons["Driver"].exists, "'Driver' category chip button should exist")
        XCTAssertTrue(app.buttons["Fairway Woodss"].exists, "'Fairway Woodss' category chip button should exist")
        XCTAssertTrue(app.buttons["Hybrid"].exists, "'Hybrid' category chip button should exist")
        XCTAssertTrue(app.buttons["Iron Set"].exists, "'Iron Set' category chip button should exist")
        XCTAssertTrue(app.buttons["Wedges"].exists, "'Wedges' category chip button should exist")
        XCTAssertTrue(app.buttons["Putter"].exists, "'Putter' category chip button should exist")

        // Verify Cancel button and dismiss
        let cancelBtn = app.buttons["btn_cancel_add_block"]
        let fallbackCancel = app.buttons["Cancel"]
        let activeCancel = cancelBtn.exists ? cancelBtn : fallbackCancel
        XCTAssertTrue(activeCancel.exists, "'Cancel' button should exist in AddBlockView")
        activeCancel.tap()

        // Verify dismissed back to ClubsView
        XCTAssertTrue(app.staticTexts["Inventory"].waitForExistence(timeout: 5), "Should return to Inventory view after cancel")
    }

    // MARK: - Leaderboard & Esports Combat Log

    @MainActor
    func testLeaderboardViewElements() throws {
        // Navigate to RANKINGS tab
        let rankingsTab = app.buttons["tab_rankings"]
        if rankingsTab.exists {
            rankingsTab.tap()
        } else {
            app.buttons["RANKINGS"].tap()
        }

        // Verify Header Section
        XCTAssertTrue(app.staticTexts["Overview"].waitForExistence(timeout: 5), "'Overview' headline should exist")
        XCTAssertTrue(app.staticTexts["COMBAT LOG // TOURNAMENT RANKINGS"].exists, "'COMBAT LOG // TOURNAMENT RANKINGS' telemetry tag should exist")

        // Verify Cybernetic Arc Gauge & Metric Pods
        XCTAssertTrue(app.staticTexts["HCP"].waitForExistence(timeout: 5), "'HCP' arc gauge label should exist")
        XCTAssertTrue(app.staticTexts["Peak HCP"].exists, "'Peak HCP' stat pod should exist")
        XCTAssertTrue(app.staticTexts["Last 5 Rnds"].exists, "'Last 5 Rnds' stat pod should exist")

        // Verify Averages
        XCTAssertTrue(app.staticTexts["Birdies"].exists, "'Birdies' metric item should exist")
        XCTAssertTrue(app.staticTexts["Pars"].exists, "'Pars' metric item should exist")

        // Verify Esports Match History Combat Log
        XCTAssertTrue(app.staticTexts["MATCH HISTORY"].exists, "'MATCH HISTORY' section header should exist")
        XCTAssertTrue(app.staticTexts["View All"].exists, "'View All' button/label should exist")
    }
}
