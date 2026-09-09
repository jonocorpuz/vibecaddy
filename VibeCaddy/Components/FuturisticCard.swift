//
//  FuturisticCard.swift
//  VibeCaddy
//
//  Reusable glassmorphic HUD card container with customizable chamfered
//  or rounded borders, neon glows, and optional corner reticle brackets.
//

import SwiftUI

public enum CardCornerStyle: Equatable, Sendable {
    case chamfered(cutSize: CGFloat = 12, corners: ChamferedCorners = .all)
    case rounded(radius: CGFloat = 14)
}

public struct FuturisticCard<Content: View>: View {
    public var cornerStyle: CardCornerStyle
    public var tint: Color
    public var borderColor: Color
    public var glowColor: Color
    public var borderWidth: CGFloat
    public var showBrackets: Bool
    public var bracketLength: CGFloat
    public var contentPadding: CGFloat
    @ViewBuilder public var content: () -> Content
    
    public init(
        cornerStyle: CardCornerStyle = .chamfered(cutSize: 12, corners: .all),
        tint: Color = NeoFuturisticTheme.surfaceDark.opacity(0.85),
        borderColor: Color = NeoFuturisticTheme.radianiteCyan.opacity(0.3),
        glowColor: Color? = nil,
        borderWidth: CGFloat = 1.0,
        showBrackets: Bool = false,
        bracketLength: CGFloat = 10,
        contentPadding: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerStyle = cornerStyle
        self.tint = tint
        self.borderColor = borderColor
        self.glowColor = glowColor ?? borderColor.opacity(0.4)
        self.borderWidth = borderWidth
        self.showBrackets = showBrackets
        self.bracketLength = bracketLength
        self.contentPadding = contentPadding
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch cornerStyle {
            case .chamfered(let cutSize, let corners):
                let shape = ChamferedRectangle(cutSize: cutSize, corners: corners)
                content()
                    .padding(contentPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                            .shadow(color: glowColor, radius: 4)
                    )
                    .overlay {
                        if showBrackets {
                            CornerBracketsShape(bracketLength: bracketLength, inset: 2)
                                .stroke(borderColor, lineWidth: 1.5)
                        }
                    }
                    
            case .rounded(let radius):
                let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
                content()
                    .padding(contentPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                            .shadow(color: glowColor, radius: 4)
                    )
                    .overlay {
                        if showBrackets {
                            CornerBracketsShape(bracketLength: bracketLength, inset: 2)
                                .stroke(borderColor, lineWidth: 1.5)
                        }
                    }
            }
        }
    }
}
