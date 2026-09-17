//
//  TacticalProgressBar.swift
//  VibeCaddy
//
//  Clean telemetry progress bar with smooth gradients, subtle track styling,
//  and no tacky glow shadows.
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
        height: CGFloat = 5,
        gradient: LinearGradient = NeoFuturisticTheme.dataGradient,
        trackColor: Color = NeoFuturisticTheme.surfaceElevated,
        showGlow: Bool = false,
        cornerRadius: CGFloat = 2.5
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
            let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            
            ZStack(alignment: .leading) {
                shape
                    .fill(trackColor)
                    .frame(height: height)
                
                if fillWidth > 0 {
                    shape
                        .fill(gradient)
                        .frame(width: fillWidth, height: height)
                }
            }
        }
        .frame(height: height)
    }
}
