//
//  TacticalProgressBar.swift
//  VibeCaddy
//
//  High-tech progress bar with neon gradient fill, glow effects, and
//  tactical track styling.
//

import SwiftUI

public struct TacticalProgressBar: View {
    public var progress: Double
    public var height: CGFloat
    public var gradient: LinearGradient
    public var trackColor: Color
    public var showGlow: Bool
    public var cornerRadius: CGFloat
    
    public init(
        progress: Double,
        height: CGFloat = 6,
        gradient: LinearGradient = NeoFuturisticTheme.cyanToGreenGradient,
        trackColor: Color = NeoFuturisticTheme.surfaceElevated,
        showGlow: Bool = true,
        cornerRadius: CGFloat = 3
    ) {
        self.progress = max(0.0, min(progress, 1.0))
        self.height = height
        self.gradient = gradient
        self.trackColor = trackColor
        self.showGlow = showGlow
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let fillWidth = totalWidth * CGFloat(progress)
            
            ZStack(alignment: .leading) {
                // Background Track
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(trackColor)
                    .frame(height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(NeoFuturisticTheme.textMuted.opacity(0.3), lineWidth: 0.5)
                    )
                
                // Progress Fill
                if fillWidth > 0 {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(gradient)
                        .frame(width: fillWidth, height: height)
                        .shadow(color: showGlow ? NeoFuturisticTheme.radianiteCyan.opacity(0.6) : .clear, radius: 4)
                }
            }
        }
        .frame(height: height)
    }
}
