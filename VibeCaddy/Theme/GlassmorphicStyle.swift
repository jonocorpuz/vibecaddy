//
//  GlassmorphicStyle.swift
//  VibeCaddy
//
//  Clean container styling for the Valorant Neo premium aesthetic:
//  smooth rounded corners, subtle 1px semi-transparent borders,
//  and solid dark slate backgrounds without tacky glow shadows.
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
        tint: Color = NeoFuturisticTheme.surfacePrimary,
        borderColor: Color = NeoFuturisticTheme.borderSubtle,
        borderWidth: CGFloat = 1.0,
        cornerRadius: CGFloat = 14,
        glowRadius: CGFloat = 0,
        glowColor: Color? = nil
    ) {
        self.tint = tint
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.glowRadius = glowRadius
        self.glowColor = glowColor ?? .clear
    }
    
    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        content
            .background(shape.fill(tint))
            .overlay(shape.stroke(borderColor, lineWidth: borderWidth))
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
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
        cutSize: CGFloat = 10,
        corners: ChamferedCorners = .all,
        tint: Color = NeoFuturisticTheme.surfacePrimary,
        borderColor: Color = NeoFuturisticTheme.borderSubtle,
        borderWidth: CGFloat = 1.0,
        glowRadius: CGFloat = 0,
        glowColor: Color? = nil
    ) {
        self.cutSize = cutSize
        self.corners = corners
        self.tint = tint
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.glowRadius = glowRadius
        self.glowColor = glowColor ?? .clear
    }
    
    public func body(content: Content) -> some View {
        let shape = ChamferedRectangle(cutSize: cutSize, corners: corners)
        
        content
            .background(shape.fill(tint))
            .overlay(shape.stroke(borderColor, lineWidth: borderWidth))
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

// MARK: - View Convenience Extensions

extension View {
    /// Applies a clean rounded container background with subtle 1px border and soft elevation shadow.
    public func tacticalGlass(
        tint: Color = NeoFuturisticTheme.surfacePrimary,
        borderColor: Color = NeoFuturisticTheme.borderSubtle,
        borderWidth: CGFloat = 1.0,
        cornerRadius: CGFloat = 14,
        glowRadius: CGFloat = 0,
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
    
    /// Applies an angular chamfered container background with subtle border.
    public func chamferedGlass(
        cutSize: CGFloat = 10,
        corners: ChamferedCorners = .all,
        tint: Color = NeoFuturisticTheme.surfacePrimary,
        borderColor: Color = NeoFuturisticTheme.borderSubtle,
        borderWidth: CGFloat = 1.0,
        glowRadius: CGFloat = 0,
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
    
    /// Adds a subtle soft glow/shadow around the view or outline
    public func neonGlow(color: Color, radius: CGFloat = 3) -> some View {
        self.shadow(color: color.opacity(0.25), radius: radius)
    }
}
