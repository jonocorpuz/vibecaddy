//
//  HexBadge.swift
//  VibeCaddy
//
//  Tactical hexagonal and chamfered badges with glowing neon outlines
//  used for avatar frames, weapon class tags, and status telemetry.
//

import SwiftUI

public enum HexBadgeStyle: Equatable, Sendable {
    case hexagon
    case chamfered(cutSize: CGFloat = 6)
}

public struct HexBadge<Content: View>: View {
    public var style: HexBadgeStyle
    public var accentColor: Color
    public var fillColor: Color
    public var borderWidth: CGFloat
    public var glowRadius: CGFloat
    @ViewBuilder public var content: () -> Content
    
    public init(
        style: HexBadgeStyle = .chamfered(cutSize: 6),
        accentColor: Color = NeoFuturisticTheme.radianiteCyan,
        fillColor: Color = NeoFuturisticTheme.surfaceDark.opacity(0.85),
        borderWidth: CGFloat = 1.0,
        glowRadius: CGFloat = 4,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.accentColor = accentColor
        self.fillColor = fillColor
        self.borderWidth = borderWidth
        self.glowRadius = glowRadius
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch style {
            case .hexagon:
                content()
                    .padding(8)
                    .background(
                        HexagonShape()
                            .fill(.ultraThinMaterial)
                    )
                    .background(
                        HexagonShape()
                            .fill(fillColor)
                    )
                    .overlay(
                        HexagonShape()
                            .stroke(accentColor, lineWidth: borderWidth)
                            .shadow(color: accentColor.opacity(0.5), radius: glowRadius)
                    )
                    .clipShape(HexagonShape())
                
            case .chamfered(let cutSize):
                let shape = ChamferedRectangle(cutSize: cutSize, corners: .all)
                content()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        shape
                            .fill(.ultraThinMaterial)
                    )
                    .background(
                        shape
                            .fill(fillColor)
                    )
                    .overlay(
                        shape
                            .stroke(accentColor, lineWidth: borderWidth)
                            .shadow(color: accentColor.opacity(0.5), radius: glowRadius)
                    )
                    .clipShape(shape)
            }
        }
    }
}

// MARK: - Dedicated Typed Convenience Badges

public struct HexBadgeText: View {
    public var text: String
    public var style: HexBadgeStyle
    public var accentColor: Color
    public var font: Font
    
    public init(
        _ text: String,
        style: HexBadgeStyle = .chamfered(cutSize: 5),
        accentColor: Color = NeoFuturisticTheme.radianiteCyan,
        font: Font = .hudTelemetry
    ) {
        self.text = text
        self.style = style
        self.accentColor = accentColor
        self.font = font
    }
    
    public var body: some View {
        HexBadge(
            style: style,
            accentColor: accentColor,
            fillColor: accentColor.opacity(0.12)
        ) {
            Text(text.uppercased())
                .font(font)
                .foregroundStyle(accentColor)
                .hudTracking(1.2)
        }
    }
}

public struct HexBadgeIcon: View {
    public var icon: String
    public var style: HexBadgeStyle
    public var accentColor: Color
    public var iconSize: CGFloat
    
    public init(
        _ icon: String,
        style: HexBadgeStyle = .chamfered(cutSize: 8),
        accentColor: Color = NeoFuturisticTheme.radianiteCyan,
        iconSize: CGFloat = 16
    ) {
        self.icon = icon
        self.style = style
        self.accentColor = accentColor
        self.iconSize = iconSize
    }
    
    public var body: some View {
        HexBadge(
            style: style,
            accentColor: accentColor,
            fillColor: NeoFuturisticTheme.surfaceElevated.opacity(0.85)
        ) {
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .bold))
                .foregroundStyle(accentColor)
        }
    }
}
