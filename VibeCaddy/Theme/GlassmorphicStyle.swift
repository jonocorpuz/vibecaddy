//
//  GlassmorphicStyle.swift
//  VibeCaddy
//
//  Glassmorphism styling, ultra-thin material backgrounds, translucent
//  overlays, and glowing neon borders.
//

import SwiftUI

// MARK: - Rounded Glassmorphic Modifier

public struct GlassmorphicCardModifier: ViewModifier {
    public var tint: Color
    public var borderColor: Color
    public var borderWidth: CGFloat
    public var cornerRadius: CGFloat
    public var glowRadius: CGFloat
    public var glowColor: Color
    
    public init(
        tint: Color = NeoFuturisticTheme.panelDark.opacity(0.7),
        borderColor: Color = NeoFuturisticTheme.radianiteCyan.opacity(0.35),
        borderWidth: CGFloat = 1.0,
        cornerRadius: CGFloat = 14,
        glowRadius: CGFloat = 4,
        glowColor: Color? = nil
    ) {
        self.tint = tint
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.glowRadius = glowRadius
        self.glowColor = glowColor ?? borderColor.opacity(0.4)
    }
    
    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        content
            .background(
                shape
                    .fill(.ultraThinMaterial)
            )
            .background(
                shape
                    .fill(tint)
            )
            .overlay(
                shape
                    .stroke(borderColor, lineWidth: borderWidth)
                    .shadow(color: glowColor, radius: glowRadius)
            )
    }
}

// MARK: - Chamfered Glassmorphic Modifier

public struct ChamferedGlassModifier: ViewModifier {
    public var cutSize: CGFloat
    public var corners: ChamferedCorners
    public var tint: Color
    public var borderColor: Color
    public var borderWidth: CGFloat
    public var glowRadius: CGFloat
    public var glowColor: Color
    
    public init(
        cutSize: CGFloat = 12,
        corners: ChamferedCorners = .all,
        tint: Color = NeoFuturisticTheme.panelDark.opacity(0.7),
        borderColor: Color = NeoFuturisticTheme.radianiteCyan.opacity(0.35),
        borderWidth: CGFloat = 1.0,
        glowRadius: CGFloat = 4,
        glowColor: Color? = nil
    ) {
        self.cutSize = cutSize
        self.corners = corners
        self.tint = tint
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.glowRadius = glowRadius
        self.glowColor = glowColor ?? borderColor.opacity(0.4)
    }
    
    public func body(content: Content) -> some View {
        let shape = ChamferedRectangle(cutSize: cutSize, corners: corners)
        
        content
            .background(
                shape
                    .fill(.ultraThinMaterial)
            )
            .background(
                shape
                    .fill(tint)
            )
            .overlay(
                shape
                    .stroke(borderColor, lineWidth: borderWidth)
                    .shadow(color: glowColor, radius: glowRadius)
            )
    }
}

// MARK: - View Convenience Extensions

extension View {
    /// Applies a rounded glassmorphic background with translucent tint and glowing border.
    public func tacticalGlass(
        tint: Color = NeoFuturisticTheme.panelDark.opacity(0.7),
        borderColor: Color = NeoFuturisticTheme.radianiteCyan.opacity(0.35),
        borderWidth: CGFloat = 1.0,
        cornerRadius: CGFloat = 14,
        glowRadius: CGFloat = 4,
        glowColor: Color? = nil
    ) -> some View {
        self.modifier(GlassmorphicCardModifier(
            tint: tint,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius,
            glowRadius: glowRadius,
            glowColor: glowColor
        ))
    }
    
    /// Applies an angular chamfered glassmorphic background with glowing border.
    public func chamferedGlass(
        cutSize: CGFloat = 12,
        corners: ChamferedCorners = .all,
        tint: Color = NeoFuturisticTheme.panelDark.opacity(0.7),
        borderColor: Color = NeoFuturisticTheme.radianiteCyan.opacity(0.35),
        borderWidth: CGFloat = 1.0,
        glowRadius: CGFloat = 4,
        glowColor: Color? = nil
    ) -> some View {
        self.modifier(ChamferedGlassModifier(
            cutSize: cutSize,
            corners: corners,
            tint: tint,
            borderColor: borderColor,
            borderWidth: borderWidth,
            glowRadius: glowRadius,
            glowColor: glowColor
        ))
    }
    
    /// Adds a neon glow shadow around the view or outline
    public func neonGlow(color: Color, radius: CGFloat = 6) -> some View {
        self.shadow(color: color.opacity(0.7), radius: radius)
    }
}
