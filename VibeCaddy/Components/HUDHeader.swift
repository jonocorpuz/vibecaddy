//
//  HUDHeader.swift
//  VibeCaddy
//
//  Clean top header bar displaying operator identity, subtle status badge,
//  and sleek avatar tile.
//

import SwiftUI

public struct HUDHeader<Trailing: View>: View {
    public var title: String
    public var subtitle: String?
    public var statusIndicatorText: String?
    public var statusColor: Color
    public var avatarIcon: String
    public var showAvatar: Bool
    @ViewBuilder public var trailing: () -> Trailing
    
    public init(
        title: String,
        subtitle: String? = nil,
        statusIndicatorText: String? = "ONLINE",
        statusColor: Color = NeoFuturisticTheme.statusSuccess,
        avatarIcon: String = "person.fill",
        showAvatar: Bool = true,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.statusIndicatorText = statusIndicatorText
        self.statusColor = statusColor
        self.avatarIcon = avatarIcon
        self.showAvatar = showAvatar
        self.trailing = trailing
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                if let statusIndicatorText = statusIndicatorText {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 6, height: 6)
                        
                        Text(statusIndicatorText.uppercased())
                            .font(.system(size: 11, weight: .semibold, design: .default))
                            .foregroundStyle(statusColor)
                            .hudTracking(1.0)
                    }
                }
                
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
                    .hudTracking(0.2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                }
            }
            
            Spacer()
            
            trailing()
            
            if showAvatar {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(NeoFuturisticTheme.surfaceElevated)
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1.0)
                    )
                    .overlay(
                        Image(systemName: avatarIcon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(NeoFuturisticTheme.accentMagenta)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}
