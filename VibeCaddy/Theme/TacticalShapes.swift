//
//  TacticalShapes.swift
//  VibeCaddy
//
//  Custom geometric shapes for the Valorant neo-futuristic HUD aesthetic:
//  chamfered rectangles, corner brackets, crosshairs, and tactical hexagons.
//

import SwiftUI

// MARK: - Chamfered Corners OptionSet

public struct ChamferedCorners: OptionSet, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let topLeft     = ChamferedCorners(rawValue: 1 << 0)
    public static let topRight    = ChamferedCorners(rawValue: 1 << 1)
    public static let bottomRight = ChamferedCorners(rawValue: 1 << 2)
    public static let bottomLeft  = ChamferedCorners(rawValue: 1 << 3)
    
    public static let all: ChamferedCorners = [.topLeft, .topRight, .bottomRight, .bottomLeft]
    public static let diagonal: ChamferedCorners = [.topRight, .bottomLeft]
    public static let topBoth: ChamferedCorners = [.topLeft, .topRight]
    public static let bottomBoth: ChamferedCorners = [.bottomLeft, .bottomRight]
}

// MARK: - ChamferedRectangle Shape

/// A rectangle with 45-degree chamfered (beveled) corners.
public struct ChamferedRectangle: Shape {
    public var cutSize: CGFloat
    public var corners: ChamferedCorners
    
    public init(cutSize: CGFloat = 12, corners: ChamferedCorners = .all) {
        self.cutSize = cutSize
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        guard rect.width > 0 && rect.height > 0 else { return path }
        
        let maxCut = min(rect.width, rect.height) / 2
        let effectiveCut = min(max(cutSize, 0), maxCut)
        
        let tl = corners.contains(.topLeft) ? effectiveCut : 0
        let tr = corners.contains(.topRight) ? effectiveCut : 0
        let br = corners.contains(.bottomRight) ? effectiveCut : 0
        let bl = corners.contains(.bottomLeft) ? effectiveCut : 0
        
        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        if tr > 0 {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + tr))
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        if br > 0 {
            path.addLine(to: CGPoint(x: rect.maxX - br, y: rect.maxY))
        }
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        if bl > 0 {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bl))
        }
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        if tl > 0 {
            path.addLine(to: CGPoint(x: rect.minX + tl, y: rect.minY))
        }
        path.closeSubpath()
        
        return path
    }
}

// MARK: - CornerBrackets Shape & Modifier

/// HUD corner reticles (L-shaped framing brackets).
public struct CornerBracketsShape: Shape {
    public var bracketLength: CGFloat
    public var inset: CGFloat
    
    public init(bracketLength: CGFloat = 10, inset: CGFloat = 0) {
        self.bracketLength = bracketLength
        self.inset = inset
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = rect.insetBy(dx: inset, dy: inset)
        guard r.width > 0 && r.height > 0 else { return path }
        
        let len = min(bracketLength, min(r.width, r.height) / 2)
        
        // Top Left
        path.move(to: CGPoint(x: r.minX, y: r.minY + len))
        path.addLine(to: CGPoint(x: r.minX, y: r.minY))
        path.addLine(to: CGPoint(x: r.minX + len, y: r.minY))
        
        // Top Right
        path.move(to: CGPoint(x: r.maxX - len, y: r.minY))
        path.addLine(to: CGPoint(x: r.maxX, y: r.minY))
        path.addLine(to: CGPoint(x: r.maxX, y: r.minY + len))
        
        // Bottom Right
        path.move(to: CGPoint(x: r.maxX, y: r.maxY - len))
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        path.addLine(to: CGPoint(x: r.maxX - len, y: r.maxY))
        
        // Bottom Left
        path.move(to: CGPoint(x: r.minX + len, y: r.maxY))
        path.addLine(to: CGPoint(x: r.minX, y: r.maxY))
        path.addLine(to: CGPoint(x: r.minX, y: r.maxY - len))
        
        return path
    }
}

public struct CornerBracketsModifier: ViewModifier {
    public var color: Color
    public var bracketLength: CGFloat
    public var lineWidth: CGFloat
    public var inset: CGFloat
    
    public init(
        color: Color = .radianiteCyan,
        bracketLength: CGFloat = 10,
        lineWidth: CGFloat = 1.5,
        inset: CGFloat = 0
    ) {
        self.color = color
        self.bracketLength = bracketLength
        self.lineWidth = lineWidth
        self.inset = inset
    }
    
    public func body(content: Content) -> some View {
        content.overlay(
            CornerBracketsShape(bracketLength: bracketLength, inset: inset)
                .stroke(color, lineWidth: lineWidth)
        )
    }
}

extension View {
    public func cornerBrackets(
        color: Color = .radianiteCyan,
        bracketLength: CGFloat = 10,
        lineWidth: CGFloat = 1.5,
        inset: CGFloat = 0
    ) -> some View {
        self.modifier(CornerBracketsModifier(
            color: color,
            bracketLength: bracketLength,
            lineWidth: lineWidth,
            inset: inset
        ))
    }
}

// MARK: - Tactical Hexagon Shape

/// A vertical, pointy-topped tactical hexagon shape.
public struct HexagonShape: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        guard rect.width > 0 && rect.height > 0 else { return path }
        
        let midX = rect.midX
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let quarterH = rect.height * 0.25
        
        path.move(to: CGPoint(x: midX, y: minY))
        path.addLine(to: CGPoint(x: maxX, y: minY + quarterH))
        path.addLine(to: CGPoint(x: maxX, y: maxY - quarterH))
        path.addLine(to: CGPoint(x: midX, y: maxY))
        path.addLine(to: CGPoint(x: minX, y: maxY - quarterH))
        path.addLine(to: CGPoint(x: minX, y: minY + quarterH))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Tactical Crosshair Shape

/// A HUD crosshair reticle shape for targeting indicators.
public struct TacticalCrosshair: Shape {
    public var size: CGFloat
    
    public init(size: CGFloat = 8) {
        self.size = size
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let midY = rect.midY
        let half = size / 2
        
        path.move(to: CGPoint(x: midX - half, y: midY))
        path.addLine(to: CGPoint(x: midX + half, y: midY))
        path.move(to: CGPoint(x: midX, y: midY - half))
        path.addLine(to: CGPoint(x: midX, y: midY + half))
        
        return path
    }
}
