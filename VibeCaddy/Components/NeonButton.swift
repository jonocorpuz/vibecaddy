//
//  NeonButton.swift
//  VibeCaddy
//
//  Premium interactive action button with signature magenta/purple gradients,
//  smooth continuous rounded corners, haptic feedback, and clean typography.
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
    public var cornerRadius: CGFloat
    public var isFullWidth: Bool
    
    public init(
        style: NeonButtonStyleType = .primaryAction,
        cutSize: CGFloat = 12, // Mapped for backward compatibility
        isFullWidth: Bool = false
    ) {
        self.style = style
        self.cornerRadius = 12
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        NeonButtonContent(
            configuration: configuration,
            style: style,
            cornerRadius: cornerRadius,
            isFullWidth: isFullWidth
        )
    }
}

private struct NeonButtonContent: View {
    let configuration: ButtonStyle.Configuration
    let style: NeonButtonStyleType
    let cornerRadius: CGFloat
    let isFullWidth: Bool
    
    @Environment(\.isEnabled) private var isEnabled
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primaryAction:
            NeoFuturisticTheme.primaryGradient
                .opacity(configuration.isPressed ? 0.85 : 1.0)
        case .secondaryTactical:
            NeoFuturisticTheme.surfaceElevated
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        case .hazard:
            NeoFuturisticTheme.statusDanger
                .opacity(configuration.isPressed ? 0.85 : 1.0)
        }
    }
    
    private var strokeColor: Color {
        switch style {
        case .primaryAction:
            return Color.white.opacity(configuration.isPressed ? 0.3 : 0.18)
        case .secondaryTactical:
            return Color.white.opacity(0.1)
        case .hazard:
            return Color.white.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        guard isEnabled else { return NeoFuturisticTheme.textMuted }
        switch style {
        case .primaryAction, .hazard:
            return .white
        case .secondaryTactical:
            return NeoFuturisticTheme.textPrimary
        }
    }
    
    var body: some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold, design: .default))
            .foregroundStyle(textColor)
            .hudTracking(0.8)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(backgroundView)
            .clipShape(shape)
            .overlay(
                shape
                    .stroke(strokeColor, lineWidth: 1.0)
            )
            .shadow(color: Color.black.opacity(style == .primaryAction ? 0.25 : 0.1), radius: 6, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
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
