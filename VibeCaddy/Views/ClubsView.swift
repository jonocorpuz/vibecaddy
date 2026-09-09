import SwiftUI
import SwiftData

// MARK: - Club Grouping Data Structures (Public Contract)

struct ClubGroupKey: Hashable {
    let name: String
    let category: String
    
    init(name: String, category: String) {
        self.name = name
        self.category = category
    }
}

struct ClubGroup: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let clubs: [Club]
    
    init(id: UUID = UUID(), name: String, category: String, clubs: [Club]) {
        self.id = id
        self.name = name
        self.category = category
        self.clubs = clubs
    }
}

// MARK: - Category Styling Helper

func categoryAccentColor(for category: String) -> Color {
    switch category {
    case "Driver":
        return NeoFuturisticTheme.radianiteCyan
    case "Fairway Woodss":
        return Color(hex: "#00F7C4") // Cyan-green high-voltage blend
    case "Hybrid":
        return NeoFuturisticTheme.radianiteCyan
    case "Iron Set":
        return NeoFuturisticTheme.cyberGreen
    case "Wedges":
        return NeoFuturisticTheme.neonViolet
    case "Putter":
        return NeoFuturisticTheme.neonViolet
    default:
        return NeoFuturisticTheme.radianiteCyan
    }
}

func categoryIcon(for category: String) -> String {
    switch category {
    case "Driver":
        return "scope"
    case "Fairway Woodss":
        return "target"
    case "Hybrid":
        return "bolt.horizontal.fill"
    case "Iron Set":
        return "shield.fill"
    case "Wedges":
        return "flag.fill"
    case "Putter":
        return "circle.circle.fill"
    default:
        return "cross.circle"
    }
}

// MARK: - ClubsView (Armory / Weapon Loadout)

struct ClubsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var clubs: [Club]
    @State private var viewModel = ClubsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                NeoFuturisticTheme.voidBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Telemetry Status Line & Avatar
                    topStatusBar
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Inventory / Loadout Header with Add Button
                            headerSection
                            
                            // Loadout Blocks
                            let groups = viewModel.groupClubs(clubs)
                            if groups.isEmpty {
                                emptyLoadoutPlaceholder
                            } else {
                                ForEach(groups) { group in
                                    NavigationLink(destination: EditBlockView(viewModel: viewModel, group: group).navigationBarBackButtonHidden(true)) {
                                        ClubBlockCard(
                                            name: group.name,
                                            category: group.category,
                                            clubs: group.clubs
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .onAppear {
                viewModel.seedDataIfNeeded(context: modelContext, currentClubs: clubs)
            }
        }
    }
    
    // MARK: - Top Status Bar
    
    private var topStatusBar: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(NeoFuturisticTheme.cyberGreen)
                    .frame(width: 6, height: 6)
                    .shadow(color: NeoFuturisticTheme.cyberGreen.opacity(0.8), radius: 3)
                
                Text("STATUS: ARMORY ONLINE")
                    .font(.hudTelemetry)
                    .foregroundStyle(NeoFuturisticTheme.cyberGreen)
                    .hudTracking(1.2)
            }
            
            Spacer()
            
            HexBadge(style: .chamfered(cutSize: 8), accentColor: NeoFuturisticTheme.radianiteCyan) {
                Image(systemName: "person.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("ARMORY // LOADOUT")
                    .font(.hudTelemetry)
                    .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    .hudTracking(1.5)
                
                Text("Inventory")
                    .font(.hudHeadline)
                    .foregroundStyle(NeoFuturisticTheme.textPrimary)
                    .hudTracking(0.5)
            }
            
            Spacer()
            
            NavigationLink(destination: AddBlockView(viewModel: viewModel).navigationBarBackButtonHidden(true)) {
                HexBadge(style: .chamfered(cutSize: 8), accentColor: NeoFuturisticTheme.radianiteCyan, fillColor: NeoFuturisticTheme.surfaceElevated.opacity(0.9)) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(NeoFuturisticTheme.radianiteCyan)
                    }
                    .frame(width: 40, height: 40)
                }
            }
            .accessibilityIdentifier("btn_add_club")
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    // MARK: - Empty Loadout Placeholder
    
    private var emptyLoadoutPlaceholder: some View {
        FuturisticCard(
            cornerStyle: .chamfered(cutSize: 12, corners: .all),
            tint: NeoFuturisticTheme.surfaceDark.opacity(0.85),
            borderColor: NeoFuturisticTheme.radianiteCyan.opacity(0.3),
            contentPadding: 24
        ) {
            VStack(spacing: 12) {
                Image(systemName: "shield.slash")
                    .font(.system(size: 32))
                    .foregroundStyle(NeoFuturisticTheme.textSecondary)
                Text("NO LOADOUT BLOCKS REGISTERED")
                    .font(.hudSubheadline)
                    .foregroundStyle(NeoFuturisticTheme.textSecondary)
                    .hudTracking(1.2)
                Text("Tap the '+' button above to configure weapons")
                    .font(.hudCaption)
                    .foregroundStyle(NeoFuturisticTheme.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - ClubBlockCard (Valorant Weapon Loadout Card)

struct ClubBlockCard: View {
    let name: String
    let category: String
    let clubs: [Club]
    
    private var accentColor: Color {
        categoryAccentColor(for: category)
    }
    
    private var maxDistance: Double {
        switch category {
        case "Driver": return 320
        case "Fairway Woodss": return 280
        case "Hybrid": return 250
        case "Iron Set": return 230
        case "Wedges": return 160
        default: return 300
        }
    }
    
    var body: some View {
        FuturisticCard(
            cornerStyle: .chamfered(cutSize: 12, corners: .all),
            tint: NeoFuturisticTheme.panelDark.opacity(0.85),
            borderColor: accentColor.opacity(0.4),
            glowColor: accentColor.opacity(0.25),
            showBrackets: true,
            bracketLength: 8,
            contentPadding: 16
        ) {
            VStack(alignment: .leading, spacing: 14) {
                // Top Header: Name, Category Badge, and Tactical Weapon Slot Icon
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        HexBadge(
                            style: .chamfered(cutSize: 5),
                            accentColor: accentColor,
                            fillColor: accentColor.opacity(0.15)
                        ) {
                            Text(category.uppercased())
                                .font(.hudTelemetry)
                                .foregroundStyle(accentColor)
                                .hudTracking(1.2)
                        }
                        
                        Text(name)
                            .font(.hudSubheadline)
                            .foregroundStyle(NeoFuturisticTheme.textPrimary)
                            .hudTracking(0.5)
                    }
                    
                    Spacer()
                    
                    // Tactical Icon / Squircle Weapon Slot
                    ZStack {
                        ChamferedRectangle(cutSize: 8, corners: .all)
                            .fill(NeoFuturisticTheme.surfaceElevated.opacity(0.85))
                            .overlay(
                                ChamferedRectangle(cutSize: 8, corners: .all)
                                    .stroke(accentColor.opacity(0.4), lineWidth: 1)
                            )
                        
                        Image(systemName: categoryIcon(for: category))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(accentColor)
                            .shadow(color: accentColor.opacity(0.6), radius: 4)
                    }
                    .frame(width: 44, height: 44)
                }
                
                // Subtle Glowing Divider
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.5), NeoFuturisticTheme.textMuted.opacity(0.1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                
                // Clubs List with Yardages and Mini Tactical Progress Bars
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(clubs) { club in
                        let distanceStr = club.averageDistance != nil ? "\(Int(club.averageDistance!)) yds" : "--- yds"
                        
                        VStack(spacing: 4) {
                            HStack {
                                Text("\(club.type) • \(distanceStr)")
                                    .font(.system(.footnote, design: .monospaced))
                                    .foregroundStyle(NeoFuturisticTheme.textPrimary.opacity(0.9))
                                
                                Spacer()
                                
                                if let dist = club.averageDistance {
                                    Text("\(Int(dist))")
                                        .font(.hudTelemetry)
                                        .foregroundStyle(accentColor)
                                }
                            }
                            
                            if let dist = club.averageDistance {
                                TacticalProgressBar(
                                    progress: dist / maxDistance,
                                    height: 3.5,
                                    gradient: LinearGradient(
                                        colors: [accentColor.opacity(0.7), accentColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    trackColor: NeoFuturisticTheme.surfaceDark,
                                    showGlow: false,
                                    cornerRadius: 2
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - AddBlockView (Tactical Weapon Configuration)

struct AddBlockView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let viewModel: ClubsViewModel
    
    @State private var name: String = ""
    @State private var category: String = "Iron Set"
    @State private var selectedClubs: Set<String> = []
    @State private var yardages: [String: String] = [:]
    
    let categories = ["Driver", "Fairway Woodss", "Hybrid", "Iron Set", "Wedges", "Putter"]
    
    var clubsForCategory: [String] {
        switch category {
        case "Driver": return ["Driver"]
        case "Fairway Woodss": return ["3w", "5w", "7w", "9w"]
        case "Hybrid": return ["3h", "4h", "5h", "6h"]
        case "Iron Set": return ["3i", "4i", "5i", "6i", "7i", "8i", "9i", "PW"]
        case "Wedges": return ["PW", "GW", "SW", "LW"]
        case "Putter": return ["Putter"]
        default: return []
        }
    }
    
    var sortedClubsForCategory: [String] {
        let baseClubs = clubsForCategory
        return baseClubs.sorted { a, b in
            let aSelected = selectedClubs.contains(a)
            let bSelected = selectedClubs.contains(b)
            if aSelected && !bSelected { return true }
            if !aSelected && bSelected { return false }
            let aIndex = baseClubs.firstIndex(of: a) ?? 0
            let bIndex = baseClubs.firstIndex(of: b) ?? 0
            return aIndex < bIndex
        }
    }
    
    private var currentAccentColor: Color {
        categoryAccentColor(for: category)
    }
    
    var body: some View {
        ZStack {
            NeoFuturisticTheme.voidBlack
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Tactical Action Bar
                topBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Section 1: Block Type Chips
                        categorySection
                        
                        // Section 2: Nickname Field
                        nicknameSection
                        
                        // Section 3: Block Image Button
                        imageSection
                        
                        // Section 4: Club Chips & Yardage Fields
                        clubsAndYardagesSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var topBar: some View {
        HStack {
            Button("Cancel") { dismiss() }
                .font(.hudBody)
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .accessibilityIdentifier("btn_cancel_add_block")
            
            Spacer()
            
            Text("New Block")
                .font(.system(.headline, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textPrimary)
                .hudTracking(1.0)
            
            Spacer()
            
            Button("Save") { saveBlock() }
                .font(.system(.body, design: .monospaced).bold())
                .foregroundStyle(name.isEmpty || selectedClubs.isEmpty ? NeoFuturisticTheme.textMuted : NeoFuturisticTheme.cyberGreen)
                .shadow(color: (name.isEmpty || selectedClubs.isEmpty) ? .clear : NeoFuturisticTheme.cyberGreen.opacity(0.7), radius: 4)
                .disabled(name.isEmpty || selectedClubs.isEmpty)
                .accessibilityIdentifier("btn_save_add_block")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Block Type")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 10) {
                ForEach(categories, id: \.self) { cat in
                    let isSelected = category == cat
                    let catColor = categoryAccentColor(for: cat)
                    Button(action: {
                        if category != cat {
                            category = cat
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedClubs.removeAll()
                                yardages.removeAll()
                            }
                        }
                    }) {
                        Text(cat)
                            .font(.system(.footnote, design: .monospaced).bold())
                            .foregroundStyle(isSelected ? NeoFuturisticTheme.textPrimary : NeoFuturisticTheme.textSecondary)
                            .frame(height: 46)
                            .frame(maxWidth: .infinity)
                            .background(
                                ChamferedRectangle(cutSize: 6, corners: .all)
                                    .fill(isSelected ? catColor.opacity(0.2) : NeoFuturisticTheme.surfaceDark)
                            )
                            .overlay(
                                ChamferedRectangle(cutSize: 6, corners: .all)
                                    .stroke(isSelected ? catColor : NeoFuturisticTheme.textMuted.opacity(0.3), lineWidth: isSelected ? 1.5 : 1)
                                    .shadow(color: isSelected ? catColor.opacity(0.5) : .clear, radius: 4)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nickname")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            TextField("e.g. Titleist T300", text: $name)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(NeoFuturisticTheme.textPrimary)
                .tint(currentAccentColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .fill(NeoFuturisticTheme.surfaceDark)
                )
                .overlay(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .stroke(currentAccentColor.opacity(name.isEmpty ? 0.3 : 0.7), lineWidth: 1)
                        .shadow(color: name.isEmpty ? .clear : currentAccentColor.opacity(0.3), radius: 4)
                )
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Block Image (Icon)")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            Button(action: {
                // Photo picker hook
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(currentAccentColor)
                    
                    Text("Select Image...")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(NeoFuturisticTheme.textMuted)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .fill(NeoFuturisticTheme.surfaceDark)
                )
                .overlay(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .stroke(NeoFuturisticTheme.textMuted.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    private var clubsAndYardagesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Clubs & Yardages")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            VStack(spacing: 12) {
                ForEach(sortedClubsForCategory, id: \.self) { club in
                    let isSelected = selectedClubs.contains(club)
                    
                    HStack(spacing: 14) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                if isSelected {
                                    selectedClubs.remove(club)
                                } else {
                                    selectedClubs.insert(club)
                                }
                            }
                        }) {
                            Text(club)
                                .font(.system(.body, design: .monospaced).bold())
                                .foregroundStyle(isSelected ? NeoFuturisticTheme.textPrimary : NeoFuturisticTheme.textSecondary)
                                .frame(width: 76, height: 46)
                                .background(
                                    ChamferedRectangle(cutSize: 6, corners: .all)
                                        .fill(isSelected ? currentAccentColor.opacity(0.25) : NeoFuturisticTheme.surfaceDark)
                                )
                                .overlay(
                                    ChamferedRectangle(cutSize: 6, corners: .all)
                                        .stroke(isSelected ? currentAccentColor : NeoFuturisticTheme.textMuted.opacity(0.3), lineWidth: isSelected ? 1.5 : 1)
                                        .shadow(color: isSelected ? currentAccentColor.opacity(0.5) : .clear, radius: 4)
                                )
                        }
                        .buttonStyle(.plain)
                        
                        let binding = Binding<String>(
                            get: { yardages[club] ?? "" },
                            set: { yardages[club] = $0 }
                        )
                        
                        TextField("Yardage", text: binding)
                            .keyboardType(.numberPad)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(isSelected ? NeoFuturisticTheme.textPrimary : NeoFuturisticTheme.textMuted)
                            .tint(currentAccentColor)
                            .padding(.horizontal, 12)
                            .frame(width: 95, height: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(NeoFuturisticTheme.surfaceDark)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isSelected ? currentAccentColor.opacity(0.4) : NeoFuturisticTheme.textMuted.opacity(0.2), lineWidth: 1)
                            )
                            .disabled(!isSelected)
                        
                        Text("Yds")
                            .font(.system(.caption, design: .monospaced).bold())
                            .foregroundStyle(isSelected ? NeoFuturisticTheme.textSecondary : NeoFuturisticTheme.textMuted)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func saveBlock() {
        viewModel.saveNewBlock(context: modelContext, name: name, category: category, selectedClubs: selectedClubs, yardages: yardages)
        dismiss()
    }
}

// MARK: - EditBlockView (Tactical Weapon Modification)

struct EditBlockView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let viewModel: ClubsViewModel
    let originalGroup: ClubGroup
    
    @State private var name: String
    @State private var selectedClubs: Set<String>
    @State private var yardages: [String: String]
    
    init(viewModel: ClubsViewModel, group: ClubGroup) {
        self.viewModel = viewModel
        self.originalGroup = group
        _name = State(initialValue: group.name)
        _selectedClubs = State(initialValue: Set(group.clubs.map { $0.type }))
        
        var initYardages: [String: String] = [:]
        for club in group.clubs {
            if let dist = club.averageDistance {
                initYardages[club.type] = String(Int(dist))
            }
        }
        _yardages = State(initialValue: initYardages)
    }
    
    var clubsForCategory: [String] {
        switch originalGroup.category {
        case "Driver": return ["Driver"]
        case "Fairway Woodss": return ["3w", "5w", "7w", "9w"]
        case "Hybrid": return ["3h", "4h", "5h", "6h"]
        case "Iron Set": return ["3i", "4i", "5i", "6i", "7i", "8i", "9i", "PW"]
        case "Wedges": return ["PW", "GW", "SW", "LW"]
        case "Putter": return ["Putter"]
        default: return []
        }
    }
    
    var sortedClubsForCategory: [String] {
        let baseClubs = clubsForCategory
        return baseClubs.sorted { a, b in
            let aSelected = selectedClubs.contains(a)
            let bSelected = selectedClubs.contains(b)
            if aSelected && !bSelected { return true }
            if !aSelected && bSelected { return false }
            let aIndex = baseClubs.firstIndex(of: a) ?? 0
            let bIndex = baseClubs.firstIndex(of: b) ?? 0
            return aIndex < bIndex
        }
    }
    
    private var currentAccentColor: Color {
        categoryAccentColor(for: originalGroup.category)
    }
    
    var body: some View {
        ZStack {
            NeoFuturisticTheme.voidBlack
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Tactical Action Bar
                topBar
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Section 1: Nickname Field
                        nicknameSection
                        
                        // Section 2: Block Image Button
                        imageSection
                        
                        // Section 3: Club Chips & Yardages
                        clubsAndYardagesSection
                        
                        // Section 4: Tactical Destructive Action (Delete Block)
                        deleteSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var topBar: some View {
        HStack {
            Button("Cancel") { dismiss() }
                .font(.hudBody)
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .accessibilityIdentifier("btn_cancel_edit_block")
            
            Spacer()
            
            Text("Edit Block")
                .font(.system(.headline, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textPrimary)
                .hudTracking(1.0)
            
            Spacer()
            
            Button("Save") { saveBlock() }
                .font(.system(.body, design: .monospaced).bold())
                .foregroundStyle(name.isEmpty || selectedClubs.isEmpty ? NeoFuturisticTheme.textMuted : NeoFuturisticTheme.cyberGreen)
                .shadow(color: (name.isEmpty || selectedClubs.isEmpty) ? .clear : NeoFuturisticTheme.cyberGreen.opacity(0.7), radius: 4)
                .disabled(name.isEmpty || selectedClubs.isEmpty)
                .accessibilityIdentifier("btn_save_edit_block")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
    
    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nickname")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            TextField("e.g. Titleist T300", text: $name)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(NeoFuturisticTheme.textPrimary)
                .tint(currentAccentColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .fill(NeoFuturisticTheme.surfaceDark)
                )
                .overlay(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .stroke(currentAccentColor.opacity(name.isEmpty ? 0.3 : 0.7), lineWidth: 1)
                        .shadow(color: name.isEmpty ? .clear : currentAccentColor.opacity(0.3), radius: 4)
                )
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Block Image (Icon)")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            Button(action: {
                // Photo picker hook
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(currentAccentColor)
                    
                    Text("Select Image...")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(NeoFuturisticTheme.textSecondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(NeoFuturisticTheme.textMuted)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .fill(NeoFuturisticTheme.surfaceDark)
                )
                .overlay(
                    ChamferedRectangle(cutSize: 8, corners: .all)
                        .stroke(NeoFuturisticTheme.textMuted.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    private var clubsAndYardagesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Clubs & Yardages")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundStyle(NeoFuturisticTheme.textSecondary)
                .hudTracking(1.0)
            
            VStack(spacing: 12) {
                ForEach(sortedClubsForCategory, id: \.self) { club in
                    let isSelected = selectedClubs.contains(club)
                    
                    HStack(spacing: 14) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                if isSelected {
                                    selectedClubs.remove(club)
                                } else {
                                    selectedClubs.insert(club)
                                }
                            }
                        }) {
                            Text(club)
                                .font(.system(.body, design: .monospaced).bold())
                                .foregroundStyle(isSelected ? NeoFuturisticTheme.textPrimary : NeoFuturisticTheme.textSecondary)
                                .frame(width: 76, height: 46)
                                .background(
                                    ChamferedRectangle(cutSize: 6, corners: .all)
                                        .fill(isSelected ? currentAccentColor.opacity(0.25) : NeoFuturisticTheme.surfaceDark)
                                )
                                .overlay(
                                    ChamferedRectangle(cutSize: 6, corners: .all)
                                        .stroke(isSelected ? currentAccentColor : NeoFuturisticTheme.textMuted.opacity(0.3), lineWidth: isSelected ? 1.5 : 1)
                                        .shadow(color: isSelected ? currentAccentColor.opacity(0.5) : .clear, radius: 4)
                                )
                        }
                        .buttonStyle(.plain)
                        
                        let binding = Binding<String>(
                            get: { yardages[club] ?? "" },
                            set: { yardages[club] = $0 }
                        )
                        
                        TextField("Yardage", text: binding)
                            .keyboardType(.numberPad)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(isSelected ? NeoFuturisticTheme.textPrimary : NeoFuturisticTheme.textMuted)
                            .tint(currentAccentColor)
                            .padding(.horizontal, 12)
                            .frame(width: 95, height: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(NeoFuturisticTheme.surfaceDark)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isSelected ? currentAccentColor.opacity(0.4) : NeoFuturisticTheme.textMuted.opacity(0.2), lineWidth: 1)
                            )
                            .disabled(!isSelected)
                        
                        Text("Yds")
                            .font(.system(.caption, design: .monospaced).bold())
                            .foregroundStyle(isSelected ? NeoFuturisticTheme.textSecondary : NeoFuturisticTheme.textMuted)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var deleteSection: some View {
        Button(action: {
            deleteBlock()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 14, weight: .bold))
                Text("Delete Block")
                    .font(.system(.body, design: .monospaced).bold())
            }
            .foregroundStyle(NeoFuturisticTheme.hazardRed)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                ChamferedRectangle(cutSize: 8, corners: [.topRight, .bottomLeft])
                    .fill(NeoFuturisticTheme.hazardRed.opacity(0.15))
            )
            .overlay(
                ChamferedRectangle(cutSize: 8, corners: [.topRight, .bottomLeft])
                    .stroke(NeoFuturisticTheme.hazardRed.opacity(0.7), lineWidth: 1.5)
                    .shadow(color: NeoFuturisticTheme.hazardRed.opacity(0.4), radius: 6)
            )
        }
        .accessibilityIdentifier("btn_delete_block")
        .buttonStyle(.plain)
        .padding(.top, 16)
    }
    
    private func saveBlock() {
        viewModel.saveEditedBlock(context: modelContext, originalGroup: originalGroup, name: name, selectedClubs: selectedClubs, yardages: yardages)
        dismiss()
    }
    
    private func deleteBlock() {
        viewModel.deleteBlock(context: modelContext, originalGroup: originalGroup)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    ClubsView()
        .modelContainer(for: Club.self, inMemory: true)
}
