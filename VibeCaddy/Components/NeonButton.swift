//
//  NeonButton.swift
//  VibeCaddy
//
//  Tactical actuator button with haptic feedback, spring-press scaling,
//  and neon border illumination.
//

import SwiftUI
import UIKit

public enum NeonButtonStyleType: Equatable, Sendable {
    case primaryAction
    case secondaryTactical
    case hazard
}

// MARK: - ButtonStyle Implementation

public struct NeonButtonStyle: ButtonStyle {
    public var style: NeonButtonStyleType
    public var cutSize: CGFloat
    public var isFullWidth: Bool
    
    public init(
        style: NeonButtonStyleType = .primaryAction,
        cutSize: CGFloat = 8,
        isFullWidth: Bool = false
    ) {
        self.style = style
        self.cutSize = cutSize
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        NeonButtonContent(
            configuration: configuration,
            style: style,
            cutSize: cutSize,
            isFullWidth: isFullWidth
        )
    }
}

private struct NeonButtonContent: View {
    let configuration: ButtonStyle.Configuration
    let style: NeonButtonStyleType
    let cutSize: CGFloat
    let isFullWidth: Bool
    
    @Environment(\.isEnabled) private var isEnabled
    
    private var shape: ChamferedRectangle {
        ChamferedRectangle(cutSize: cutSize, corners: [.topRight, .bottomLeft])
    }
    
    private var primaryColor: Color {
        switch style {
        case .primaryAction:
            return NeoFuturisticTheme.cyberGreen
        case .secondaryTactical:
            return NeoFuturisticTheme.radianiteCyan
        case .hazard:
            return NeoFuturisticTheme.hazardRed
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primaryAction:
            return primaryColor.opacity(configuration.isPressed ? 0.35 : 0.18)
        case .secondaryTactical:
            return NeoFuturisticTheme.surfaceDark.opacity(configuration.isPressed ? 0.9 : 0.7)
        case .hazard:
            return primaryColor.opacity(configuration.isPressed ? 0.35 : 0.15)
        }
    }
    
    private var textColor: Color {
        if !isEnabled {
            return NeoFuturisticTheme.textMuted
        }
        switch style {
        case .primaryAction:
            return NeoFuturisticTheme.cyberGreen
        case .secondaryTactical:
            return NeoFuturisticTheme.textPrimary
        case .hazard:
            return NeoFuturisticTheme.hazardRed
        }
    }
    
    private var glowRadius: CGFloat {
        guard isEnabled else { return 0 }
        return configuration.isPressed ? 8 : 4
    }
    
    var body: some View {
        configuration.label
            .font(.hudSubheadline)
            .foregroundStyle(textColor)
            .hudTracking(1.5)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(
                shape
                    .fill(.ultraThinMaterial)
            )
            .background(
                shape
                    .fill(backgroundColor)
            )
            .overlay(
                shape
                    .stroke(isEnabled ? primaryColor : NeoFuturisticTheme.textMuted.opacity(0.4), lineWidth: 1.5)
                    .shadow(color: isEnabled ? primaryColor.opacity(0.6) : .clear, radius: glowRadius)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
            }
    }
}

// MARK: - Reusable NeonButton View

public struct NeonButton: View {
    public var title: String
    public var icon: String?
    public var style: NeonButtonStyleType
    public var cutSize: CGFloat
    public var isFullWidth: Bool
    public var action: () -> Void
    
    public init(
        _ title: String,
        icon: String? = nil,
        style: NeonButtonStyleType = .primaryAction,
        cutSize: CGFloat = 8,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.cutSize = cutSize
        self.isFullWidth = isFullWidth
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                }
                Text(title)
            }
        }
        .buttonStyle(NeonButtonStyle(style: style, cutSize: cutSize, isFullWidth: isFullWidth))
    }
}
