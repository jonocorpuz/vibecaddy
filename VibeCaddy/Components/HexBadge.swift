//
//  HexBadge.swift
//  VibeCaddy
//
//  Clean pill and rounded telemetry badge used for status tags,
//  club categories, and metric indicators.
//

import SwiftUI

public enum HexBadgeStyle: Equatable, Sendable {
    case hexagon
    case chamfered(cutSize: CGFloat = 6)
    case rounded(radius: CGFloat = 6)
}

public struct HexBadge<Content: View>: View {
    public var style: HexBadgeStyle
    public var accentColor: Color
    public var fillColor: Color
    public var borderWidth: CGFloat
    public var glowRadius: CGFloat
    @ViewBuilder public var content: () -> Content
    
    public init(
        style: HexBadgeStyle = .rounded(radius: 6),
        accentColor: Color = NeoFuturisticTheme.dataCyan,
        fillColor: Color? = nil,
        borderWidth: CGFloat = 1.0,
        glowRadius: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.accentColor = accentColor
        self.fillColor = fillColor ?? accentColor.opacity(0.12)
        self.borderWidth = borderWidth
        self.glowRadius = glowRadius
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch style {
            case .hexagon:
                let shape = HexagonShape()
                content()
                    .padding(8)
                    .background(shape.fill(fillColor))
                    .overlay(shape.stroke(accentColor.opacity(0.3), lineWidth: borderWidth))
                    .clipShape(shape)
                    
            case .chamfered(let cutSize):
                let shape = ChamferedRectangle(cutSize: cutSize, corners: .all)
                content()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(shape.fill(fillColor))
                    .overlay(shape.stroke(accentColor.opacity(0.3), lineWidth: borderWidth))
                    .clipShape(shape)
                    
            case .rounded(let radius):
                let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
                content()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(shape.fill(fillColor))
                    .overlay(shape.stroke(accentColor.opacity(0.3), lineWidth: borderWidth))
                    .clipShape(shape)
            }
        }
    }
}

public struct HexBadgeText: View {
    public var text: String
    public var style: HexBadgeStyle
    public var accentColor: Color
    public var font: Font
    
    public init(
        _ text: String,
        style: HexBadgeStyle = .rounded(radius: 6),
        accentColor: Color = NeoFuturisticTheme.dataCyan,
        font: Font = .system(size: 11, weight: .semibold, design: .default)
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
                .hudTracking(1.0)
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
        style: HexBadgeStyle = .rounded(radius: 8),
        accentColor: Color = NeoFuturisticTheme.dataCyan,
        iconSize: CGFloat = 14
    ) {
        self.icon = icon
        self.style = style
        self.accentColor = accentColor
        self.iconSize = iconSize
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(NeoFuturisticTheme.surfaceElevated)
            .frame(width: iconSize + 16, height: iconSize + 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1.0)
            )
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundStyle(accentColor)
            )
    }
}
