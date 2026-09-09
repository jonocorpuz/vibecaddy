//
//  ThemeTests.swift
//  VibeCaddyTests
//
//  Unit tests verifying the Neo-Futuristic Design System tokens,
//  hex color parsing, typography, tactical shapes, and HUD components.
//

import Testing
import SwiftUI
@testable import VibeCaddy

struct ThemeTests {

    // MARK: - Hex Color Parsing Tests

    @Test func testHexColorParsingStandard6Char() {
        let colorWithHash = Color(hex: "#00FF87")
        let colorWithoutHash = Color(hex: "00FF87")
        
        #expect(colorWithHash != Color.clear)
        #expect(colorWithoutHash != Color.clear)
    }

    @Test func testHexColorParsing8CharAlpha() {
        let colorWithAlpha = Color(hex: "#00F0FF80")
        let colorFullAlpha = Color(hex: "00F0FFFF")
        
        #expect(colorWithAlpha != Color.clear)
        #expect(colorFullAlpha != Color.clear)
    }

    @Test func testHexColorParsing3Char() {
        let color3CharWithHash = Color(hex: "#FFF")
        let color3CharWithoutHash = Color(hex: "00F")
        
        #expect(color3CharWithHash != Color.clear)
        #expect(color3CharWithoutHash != Color.clear)
    }

    @Test func testHexColorGracefulFallbackOnInvalid() {
        let invalid1 = Color(hex: "")
        let invalid2 = Color(hex: "NOT_A_HEX")
        let invalid3 = Color(hex: "#ZZZZZZ")
        let invalid4 = Color(hex: "#12") // invalid length
        
        // Invalid hex colors should fall back gracefully to a clear/zero color without crashing
        #expect(invalid1 == Color.clear)
        #expect(invalid2 == Color.clear)
        #expect(invalid3 == Color.clear)
        #expect(invalid4 == Color.clear)
    }

    // MARK: - Color Token Verification Tests

    @Test func testThemePaletteTokens() {
        #expect(NeoFuturisticTheme.voidBlack != Color.clear)
        #expect(NeoFuturisticTheme.panelDark != Color.clear)
        #expect(NeoFuturisticTheme.surfaceDark != Color.clear)
        #expect(NeoFuturisticTheme.surfaceElevated != Color.clear)
        #expect(NeoFuturisticTheme.cyberGreen != Color.clear)
        #expect(NeoFuturisticTheme.radianiteCyan != Color.clear)
        #expect(NeoFuturisticTheme.hazardRed != Color.clear)
        #expect(NeoFuturisticTheme.neonViolet != Color.clear)
        #expect(NeoFuturisticTheme.textPrimary != Color.clear)
        #expect(NeoFuturisticTheme.textSecondary != Color.clear)
        #expect(NeoFuturisticTheme.textMuted != Color.clear)
    }

    @Test func testColorExtensionsMatchTheme() {
        #expect(Color.voidBlack == NeoFuturisticTheme.voidBlack)
        #expect(Color.panelDark == NeoFuturisticTheme.panelDark)
        #expect(Color.surfaceDark == NeoFuturisticTheme.surfaceDark)
        #expect(Color.surfaceElevated == NeoFuturisticTheme.surfaceElevated)
        #expect(Color.cyberGreen == NeoFuturisticTheme.cyberGreen)
        #expect(Color.radianiteCyan == NeoFuturisticTheme.radianiteCyan)
        #expect(Color.hazardRed == NeoFuturisticTheme.hazardRed)
        #expect(Color.neonViolet == NeoFuturisticTheme.neonViolet)
        #expect(Color.textPrimary == NeoFuturisticTheme.textPrimary)
        #expect(Color.textSecondary == NeoFuturisticTheme.textSecondary)
        #expect(Color.textMuted == NeoFuturisticTheme.textMuted)
    }

    // MARK: - Typography Tokens Tests

    @Test func testTypographyTokensExist() {
        let headline = NeoFuturisticTheme.hudHeadline
        let title = NeoFuturisticTheme.hudTitle
        let subheadline = NeoFuturisticTheme.hudSubheadline
        let body = NeoFuturisticTheme.hudBody
        let caption = NeoFuturisticTheme.hudCaption
        let telemetry = NeoFuturisticTheme.hudTelemetry
        
        #expect(headline == Font.hudHeadline)
        #expect(title == Font.hudTitle)
        #expect(subheadline == Font.hudSubheadline)
        #expect(body == Font.hudBody)
        #expect(caption == Font.hudCaption)
        #expect(telemetry == Font.hudTelemetry)
    }

    // MARK: - Tactical Shapes Tests

    @Test func testChamferedRectanglePathGeneration() {
        let shape = ChamferedRectangle(cutSize: 10, corners: .all)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect)
        
        #expect(!path.isEmpty)
        #expect(path.boundingRect.width > 0)
        #expect(path.boundingRect.height > 0)
    }

    @Test func testChamferedRectangleClampsCutSize() {
        let excessiveCut = ChamferedRectangle(cutSize: 500, corners: .all)
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let path = excessiveCut.path(in: rect)
        
        #expect(!path.isEmpty)
        #expect(path.boundingRect.width <= 50)
    }

    @Test func testCornerBracketsShapePathGeneration() {
        let brackets = CornerBracketsShape(bracketLength: 12, inset: 2)
        let rect = CGRect(x: 0, y: 0, width: 150, height: 80)
        let path = brackets.path(in: rect)
        
        #expect(!path.isEmpty)
    }

    @Test func testHexagonShapePathGeneration() {
        let hex = HexagonShape()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 60)
        let path = hex.path(in: rect)
        
        #expect(!path.isEmpty)
    }

    @Test func testTacticalCrosshairPathGeneration() {
        let crosshair = TacticalCrosshair(size: 10)
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let path = crosshair.path(in: rect)
        
        #expect(!path.isEmpty)
    }

    // MARK: - Tactical Components Initialization Tests

    @Test func testProgressBarProgressClamping() {
        let barNegative = TacticalProgressBar(progress: -0.5)
        let barOverOne = TacticalProgressBar(progress: 1.5)
        let barNormal = TacticalProgressBar(progress: 0.75)
        
        #expect(barNegative.progress == 0.0)
        #expect(barOverOne.progress == 1.0)
        #expect(barNormal.progress == 0.75)
    }

    @Test func testHUDHeaderProperties() {
        let header = HUDHeader(
            title: "OPERATOR: TEST",
            subtitle: "ALL SYSTEMS GO",
            statusIndicatorText: "ONLINE",
            statusColor: NeoFuturisticTheme.cyberGreen,
            avatarIcon: "person.fill",
            showAvatar: true
        )
        
        #expect(header.title == "OPERATOR: TEST")
        #expect(header.subtitle == "ALL SYSTEMS GO")
        #expect(header.statusIndicatorText == "ONLINE")
        #expect(header.statusColor == NeoFuturisticTheme.cyberGreen)
        #expect(header.avatarIcon == "person.fill")
        #expect(header.showAvatar == true)
    }

    @Test func testNeonButtonProperties() {
        let button = NeonButton("START", icon: "play.fill", style: .primaryAction, cutSize: 8, isFullWidth: true) {}
        
        #expect(button.title == "START")
        #expect(button.icon == "play.fill")
        #expect(button.style == .primaryAction)
        #expect(button.cutSize == 8)
        #expect(button.isFullWidth == true)
    }
}
