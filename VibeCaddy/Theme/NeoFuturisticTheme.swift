//
//  NeoFuturisticTheme.swift
//  VibeCaddy
//
//  Centralized design tokens and theme engine for the Valorant Neo
//  premium aesthetic. Features deep slate canvas, muted magenta/purple accents,
//  subtle cyan/teal data highlights, and modern sans-serif typography.
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
    // MARK: - Canvas & Surface Tokens (Slate / Navy Palette)
    /// Main app canvas background (#1A1C23)
    public static let slateBackground = Color(hex: "#1A1C23")
    
    /// Primary container surface for cards and sheets (#222530)
    public static let surfacePrimary = Color(hex: "#222530")
    
    /// Elevated interactive surface for selected states and active rows (#282C3A)
    public static let surfaceElevated = Color(hex: "#282C3A")
    
    /// Inset subtle surface for progress tracks and inputs (#1E2029)
    public static let surfaceSubtle = Color(hex: "#1E2029")
    
    // MARK: - Primary Accent Tokens (Muted Magenta & Violet)
    /// Signature Valorant Neo primary magenta accent (#9D4EDD)
    public static let accentMagenta = Color(hex: "#9D4EDD")
    
    /// Deep rich purple gradient termination (#7B2CBF)
    public static let accentPurple = Color(hex: "#7B2CBF")
    
    /// Prestige violet accent highlight (#8A2BE2)
    public static let accentViolet = Color(hex: "#8A2BE2")
    
    // MARK: - Data Highlight Tokens (Muted Cyan & Teal)
    /// Subtle cyan telemetry highlight (#48CAE4)
    public static let dataCyan = Color(hex: "#48CAE4")
    
    /// Fresh teal secondary telemetry highlight (#00F5D4)
    public static let dataTeal = Color(hex: "#00F5D4")
    
    // MARK: - Functional Status Tokens
    /// Clean emerald status token for birdies, online status, positive states (#10B981)
    public static let statusSuccess = Color(hex: "#10B981")
    
    /// Clean rose/coral token for bogeys, hazards, and alerts (#F43F5E)
    public static let statusDanger = Color(hex: "#F43F5E")
    
    /// Clean amber token for warnings and par indicators (#F59E0B)
    public static let statusWarning = Color(hex: "#F59E0B")
    
    // MARK: - Typography & Content Tokens
    /// Off-white high contrast readable text (#F8FAFC)
    public static let textPrimary = Color(hex: "#F8FAFC")
    
    /// Clean slate secondary label text (#94A3B8)
    public static let textSecondary = Color(hex: "#94A3B8")
    
    /// Muted slate text for disabled or background elements (#64748B)
    public static let textMuted = Color(hex: "#64748B")
    
    // MARK: - Border & Stroke Tokens
    /// Subtle 1px container stroke
    public static let borderSubtle = Color.white.opacity(0.08)
    
    /// Medium container stroke
    public static let borderMedium = Color.white.opacity(0.12)
    
    /// Accent magenta container stroke
    public static let borderAccent = Color(hex: "#9D4EDD").opacity(0.35)
    
    // MARK: - Typography Tokens (Clean Sans-Serif)
    /// Major section header: 24pt bold sans-serif
    public static let hudHeadline = Font.system(size: 24, weight: .bold, design: .default)
    
    /// Tactical title: 20pt bold sans-serif
    public static let hudTitle = Font.system(size: 20, weight: .bold, design: .default)
    
    /// Sub-panel header: 16pt semibold sans-serif
    public static let hudSubheadline = Font.system(size: 16, weight: .semibold, design: .default)
    
    /// Clean body text: 14pt regular sans-serif
    public static let hudBody = Font.system(size: 14, weight: .regular, design: .default)
    
    /// Small indicator label: 12pt medium sans-serif
    public static let hudCaption = Font.system(size: 12, weight: .medium, design: .default)
    
    /// Compact sensor telemetry / status tag: 11pt semibold sans-serif
    public static let hudTelemetry = Font.system(size: 11, weight: .semibold, design: .default)
    
    // MARK: - Gradients
    /// Signature Neo gradient (magenta -> purple)
    public static let primaryGradient = LinearGradient(
        colors: [accentMagenta, accentPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Clean data telemetry gradient (cyan -> teal)
    public static let dataGradient = LinearGradient(
        colors: [dataCyan, dataTeal],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Subtle container top-light reflection border gradient
    public static let cardBorderGradient = LinearGradient(
        colors: [Color.white.opacity(0.14), Color.white.opacity(0.04)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Backward Compatibility Aliases
    public static let voidBlack = slateBackground
    public static let panelDark = surfacePrimary
    public static let surfaceDark = surfacePrimary
    public static let cyberGreen = statusSuccess
    public static let radianiteCyan = dataCyan
    public static let hazardRed = statusDanger
    public static let neonViolet = accentMagenta
    public static let cyanToGreenGradient = dataGradient
    public static let cyanToClearGradient = LinearGradient(
        colors: [dataCyan.opacity(0.4), Color.clear],
        startPoint: .top,
        endPoint: .bottom
    )
    public static let hazardGradient = LinearGradient(
        colors: [statusDanger, statusDanger.opacity(0.4)],
        startPoint: .leading,
        endPoint: .trailing
    )
    public static let violetToCyanGradient = LinearGradient(
        colors: [accentMagenta, dataCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    public static let glassOverlay = surfacePrimary.opacity(0.85)
}

// MARK: - Color Convenience Extensions

extension Color {
    public static let slateBackground = NeoFuturisticTheme.slateBackground
    public static let surfacePrimary = NeoFuturisticTheme.surfacePrimary
    public static let surfaceElevated = NeoFuturisticTheme.surfaceElevated
    public static let surfaceSubtle = NeoFuturisticTheme.surfaceSubtle
    public static let accentMagenta = NeoFuturisticTheme.accentMagenta
    public static let accentPurple = NeoFuturisticTheme.accentPurple
    public static let accentViolet = NeoFuturisticTheme.accentViolet
    public static let dataCyan = NeoFuturisticTheme.dataCyan
    public static let dataTeal = NeoFuturisticTheme.dataTeal
    public static let statusSuccess = NeoFuturisticTheme.statusSuccess
    public static let statusDanger = NeoFuturisticTheme.statusDanger
    public static let statusWarning = NeoFuturisticTheme.statusWarning
    
    public static let voidBlack = NeoFuturisticTheme.voidBlack
    public static let panelDark = NeoFuturisticTheme.panelDark
    public static let surfaceDark = NeoFuturisticTheme.surfaceDark
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
    /// Applies subtle letter-spacing to text elements
    public func hudTracking(_ value: CGFloat = 1.0) -> some View {
        self.tracking(value)
    }
}
