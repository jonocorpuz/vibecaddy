//
//  NeoFuturisticTheme.swift
//  VibeCaddy
//
//  Centralized design tokens and theme engine for the Valorant-inspired
//  neo-futuristic tactical HUD aesthetic.
//

import SwiftUI

// MARK: - Color Hex Initializer

extension Color {
    /// Initializes a SwiftUI Color from a hexadecimal string.
    /// Supports `#RRGGBB`, `RRGGBB`, `#RRGGBBAA`, `RRGGBBAA`, and 3-digit `#RGB`.
    /// Gracefully falls back to `.clear` if the string cannot be parsed.
    public init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "#")))
        
        var int: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&int) else {
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        
        let red, green, blue, opacity: Double
        switch cleaned.count {
        case 3: // RGB (12-bit)
            red     = Double((int >> 8) * 17) / 255.0
            green   = Double((int >> 4 & 0xF) * 17) / 255.0
            blue    = Double((int & 0xF) * 17) / 255.0
            opacity = 1.0
        case 6: // RRGGBB (24-bit)
            red     = Double((int >> 16) & 0xFF) / 255.0
            green   = Double((int >> 8) & 0xFF) / 255.0
            blue    = Double(int & 0xFF) / 255.0
            opacity = 1.0
        case 8: // RRGGBBAA (32-bit)
            red     = Double((int >> 24) & 0xFF) / 255.0
            green   = Double((int >> 16) & 0xFF) / 255.0
            blue    = Double((int >> 8) & 0xFF) / 255.0
            opacity = Double(int & 0xFF) / 255.0
        default:
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - NeoFuturisticTheme Namespace

public enum NeoFuturisticTheme {
    // MARK: Palette Tokens
    /// Deep OLED canvas background (#0A0E14)
    public static let voidBlack = Color(hex: "#0A0E14")
    
    /// Tactical card & panel base fill (#0D1117)
    public static let panelDark = Color(hex: "#0D1117")
    
    /// Elevated tactical container fill (#121820)
    public static let surfaceDark = Color(hex: "#121820")
    
    /// Accent elevated surface (#18202C)
    public static let surfaceElevated = Color(hex: "#18202C")
    
    /// High-voltage active, birdies, positive delta (#00FF87)
    public static let cyberGreen = Color(hex: "#00FF87")
    
    /// Tactical reticles, active navigation, weather/radar telemetry (#00F0FF)
    public static let radianiteCyan = Color(hex: "#00F0FF")
    
    /// Warning, bogeys, delete actions, danger alerts (#FF4655)
    public static let hazardRed = Color(hex: "#FF4655")
    
    /// Prestige metrics, peak stats, special weapon badges (#9B51E0)
    public static let neonViolet = Color(hex: "#9B51E0")
    
    /// Primary high-contrast tactical readout text (#FFFFFF)
    public static let textPrimary = Color(hex: "#FFFFFF")
    
    /// Secondary telemetry label text (#8B949E)
    public static let textSecondary = Color(hex: "#8B949E")
    
    /// Muted tactical border / grid text (#484F58)
    public static let textMuted = Color(hex: "#484F58")
    
    /// Translucent dark overlay for glassmorphic surfaces (#151C26 at 65% opacity)
    public static let glassOverlay = Color(hex: "#151C26").opacity(0.65)
    
    // MARK: - Typography Tokens
    /// Major section header: 24pt bold monospaced
    public static let hudHeadline = Font.system(size: 24, weight: .bold, design: .monospaced)
    
    /// Tactical title: 20pt bold monospaced
    public static let hudTitle = Font.system(size: 20, weight: .bold, design: .monospaced)
    
    /// Sub-panel header: 16pt semibold monospaced
    public static let hudSubheadline = Font.system(size: 16, weight: .semibold, design: .monospaced)
    
    /// Tactical body text: 14pt regular monospaced
    public static let hudBody = Font.system(size: 14, weight: .regular, design: .monospaced)
    
    /// Small indicator label: 12pt medium monospaced
    public static let hudCaption = Font.system(size: 12, weight: .medium, design: .monospaced)
    
    /// Compact sensor telemetry / status tag: 11pt heavy monospaced
    public static let hudTelemetry = Font.system(size: 11, weight: .heavy, design: .monospaced)

    // MARK: - Gradients
    public static let cyanToGreenGradient = LinearGradient(
        colors: [radianiteCyan, cyberGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let cyanToClearGradient = LinearGradient(
        colors: [radianiteCyan.opacity(0.6), Color.clear],
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let hazardGradient = LinearGradient(
        colors: [hazardRed, hazardRed.opacity(0.4)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let violetToCyanGradient = LinearGradient(
        colors: [neonViolet, radianiteCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Color Convenience Extensions

extension Color {
    public static let voidBlack = NeoFuturisticTheme.voidBlack
    public static let panelDark = NeoFuturisticTheme.panelDark
    public static let surfaceDark = NeoFuturisticTheme.surfaceDark
    public static let surfaceElevated = NeoFuturisticTheme.surfaceElevated
    public static let cyberGreen = NeoFuturisticTheme.cyberGreen
    public static let radianiteCyan = NeoFuturisticTheme.radianiteCyan
    public static let hazardRed = NeoFuturisticTheme.hazardRed
    public static let neonViolet = NeoFuturisticTheme.neonViolet
    public static let textPrimary = NeoFuturisticTheme.textPrimary
    public static let textSecondary = NeoFuturisticTheme.textSecondary
    public static let textMuted = NeoFuturisticTheme.textMuted
}

// MARK: - Font Convenience Extensions

extension Font {
    public static let hudHeadline = NeoFuturisticTheme.hudHeadline
    public static let hudTitle = NeoFuturisticTheme.hudTitle
    public static let hudSubheadline = NeoFuturisticTheme.hudSubheadline
    public static let hudBody = NeoFuturisticTheme.hudBody
    public static let hudCaption = NeoFuturisticTheme.hudCaption
    public static let hudTelemetry = NeoFuturisticTheme.hudTelemetry
}

// MARK: - View Tracking Modifier

extension View {
    /// Applies uppercase tactical letter-spacing to text elements
    public func hudTracking(_ value: CGFloat = 1.5) -> some View {
        self.tracking(value)
    }
}
