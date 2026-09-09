//
//  HUDHeader.swift
//  VibeCaddy
//
//  Top HUD bar component displaying the operator identity, telemetry status,
//  and tactical avatar badge.
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
        statusColor: Color = NeoFuturisticTheme.cyberGreen,
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
                            .shadow(color: statusColor.opacity(0.8), radius: 3)
                        
                        Text(statusIndicatorText.uppercased())
                            .font(.hudTelemetry)
                            .foregroundStyle(statusColor)
                            .hudTracking(1.2)
                    }
                }
                
                Text(title)
                    .font(.hudHeadline)
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
                    .hudTracking(1.0)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.hudCaption)
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                        .hudTracking(0.8)
                }
            }
            
            Spacer()
            
            trailing()
            
            if showAvatar {
                HexBadge(style: .chamfered(cutSize: 8), accentColor: NeoFuturisticTheme.radianiteCyan) {
                    Image(systemName: avatarIcon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}
