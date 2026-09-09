//
//  FuturisticCard.swift
//  VibeCaddy
//
//  Clean, premium card container featuring smooth continuous rounded corners,
//  subtle 1px semi-transparent borders, and rich dark slate background fills.
//

import SwiftUI

public enum CardCornerStyle: Equatable, Sendable {
    case chamfered(cutSize: CGFloat = 10, corners: ChamferedCorners = .all)
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
        cornerStyle: CardCornerStyle = .rounded(radius: 14),
        tint: Color = NeoFuturisticTheme.surfacePrimary,
        borderColor: Color = NeoFuturisticTheme.borderSubtle,
        glowColor: Color? = nil,
        borderWidth: CGFloat = 1.0,
        showBrackets: Bool = false,
        bracketLength: CGFloat = 8,
        contentPadding: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerStyle = cornerStyle
        self.tint = tint
        self.borderColor = borderColor
        self.glowColor = glowColor ?? .clear
        self.borderWidth = borderWidth
        self.showBrackets = showBrackets
        self.bracketLength = bracketLength
        self.contentPadding = contentPadding
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch cornerStyle {
            case .rounded(let radius):
                let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
                content()
                    .padding(contentPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(shape.fill(tint))
                    .overlay(shape.stroke(borderColor, lineWidth: borderWidth))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                    .overlay {
                        if showBrackets {
                            CornerBracketsShape(bracketLength: bracketLength, inset: 2)
                                .stroke(borderColor, lineWidth: 1.0)
                        }
                    }
                    
            case .chamfered(let cutSize, let corners):
                let shape = ChamferedRectangle(cutSize: cutSize, corners: corners)
                content()
                    .padding(contentPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(shape.fill(tint))
                    .overlay(shape.stroke(borderColor, lineWidth: borderWidth))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                    .overlay {
                        if showBrackets {
                            CornerBracketsShape(bracketLength: bracketLength, inset: 2)
                                .stroke(borderColor, lineWidth: 1.0)
                        }
                    }
            }
        }
    }
}
