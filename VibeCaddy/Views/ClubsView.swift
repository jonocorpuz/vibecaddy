import SwiftUI

// MARK: - Club Grouping Data Structures

struct ClubGroupKey: Hashable {
    let name: String
    let category: String
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

// MARK: - Category Styling Helpers

func categoryAccentColor(for category: String) -> Color {
    switch category {
    case "Driver":      return NeoFuturisticTheme.radianiteCyan
    case "Fairway Woodss": return Color(hex: "#00F7C4")
    case "Hybrid":      return NeoFuturisticTheme.radianiteCyan
    case "Iron Set":    return NeoFuturisticTheme.cyberGreen
    case "Wedges":      return NeoFuturisticTheme.neonViolet
    case "Putter":      return NeoFuturisticTheme.neonViolet
    default:            return NeoFuturisticTheme.radianiteCyan
    }
}

func categoryIcon(for category: String) -> String {
    switch category {
    case "Driver":         return "scope"
    case "Fairway Woodss": return "target"
    case "Hybrid":         return "bolt.horizontal.fill"
    case "Iron Set":       return "shield.fill"
    case "Wedges":         return "flag.fill"
    case "Putter":         return "circle.circle.fill"
    default:               return "cross.circle"
    }
}

// MARK: - ClubsView

struct ClubsView: View {
    @Environment(ClubsViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            ZStack {
                NeoFuturisticTheme.slateBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            headerSection

                            if viewModel.clubGroups.isEmpty {
                                emptyLoadoutPlaceholder
                            } else {
                                ForEach(viewModel.clubGroups) { group in
                                    NavigationLink(
                                        destination: EditBlockView(group: group)
                                            .navigationBarBackButtonHidden(true)
                                    ) {
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
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .center) {
            Text("Inventory")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundStyle(Color.white)
                .hudTracking(0.5)

            Spacer()

            NavigationLink(destination: AddBlockView().navigationBarBackButtonHidden(true)) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: "#232836"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1.0)
                    )
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color(hex: "#00F0FF"))
                    )
            }
            .accessibilityIdentifier("btn_add_club")
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    // MARK: - Empty State

    private var emptyLoadoutPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "shield.slash")
                .font(.system(size: 32))
                .foregroundStyle(Color(hex: "#8F9AA9"))
            Text("NO LOADOUT BLOCKS REGISTERED")
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(1.0)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#202430")))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1.0))
        .padding(.horizontal, 24)
    }
}

// MARK: - ClubBlockCard

struct ClubBlockCard: View {
    let name: String
    let category: String
    let clubs: [Club]

    private var accentColor: Color { categoryAccentColor(for: category) }

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
        VStack(alignment: .leading, spacing: 14) {
            // Header row: category pill, name, icon
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(category.uppercased())
                        .font(.system(size: 11, weight: .semibold, design: .default))
                        .foregroundStyle(accentColor)
                        .hudTracking(1.0)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(accentColor.opacity(0.12)))
                        .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(accentColor.opacity(0.3), lineWidth: 1.0))

                    Text(name)
                        .font(.system(size: 17, weight: .bold, design: .default))
                        .foregroundStyle(Color.white)
                        .hudTracking(0.3)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(hex: "#262B38"))
                        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1.0))
                    Image(systemName: categoryIcon(for: category))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(accentColor)
                }
                .frame(width: 44, height: 44)
            }

            Rectangle().fill(Color.white.opacity(0.06)).frame(height: 1)

            // Club rows
            VStack(alignment: .leading, spacing: 10) {
                ForEach(clubs) { club in
                    let distanceStr = club.averageDistance != nil ? "\(Int(club.averageDistance!)) yds" : "--- yds"

                    VStack(spacing: 4) {
                        HStack {
                            Text("\(club.type) • \(distanceStr)")
                                .font(.system(size: 13, weight: .medium, design: .default))
                                .foregroundStyle(Color.white.opacity(0.9))
                            Spacer()
                            if let dist = club.averageDistance {
                                Text("\(Int(dist))")
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                    .foregroundStyle(accentColor)
                            }
                        }

                        if let dist = club.averageDistance {
                            TacticalProgressBar(
                                progress: dist / maxDistance,
                                height: 4,
                                gradient: LinearGradient(colors: [accentColor.opacity(0.7), accentColor], startPoint: .leading, endPoint: .trailing),
                                trackColor: Color(hex: "#161922"),
                                showGlow: false,
                                cornerRadius: 2
                            )
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#202430")))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1.0))
        .padding(.horizontal, 24)
    }
}

// MARK: - AddBlockView

struct AddBlockView: View {
    @Environment(ClubsViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var category: String = "Iron Set"
    @State private var selectedClubs: Set<String> = []
    @State private var yardages: [String: String] = [:]

    let categories = ["Driver", "Fairway Woodss", "Hybrid", "Iron Set", "Wedges", "Putter"]

    private var clubsForCategory: [String] {
        switch category {
        case "Driver":         return ["Driver"]
        case "Fairway Woodss": return ["3w", "5w", "7w", "9w"]
        case "Hybrid":         return ["3h", "4h", "5h", "6h"]
        case "Iron Set":       return ["3i", "4i", "5i", "6i", "7i", "8i", "9i", "PW"]
        case "Wedges":         return ["PW", "GW", "SW", "LW"]
        case "Putter":         return ["Putter"]
        default:               return []
        }
    }

    private var sortedClubsForCategory: [String] {
        clubsForCategory.sorted { a, b in
            let aSelected = selectedClubs.contains(a)
            let bSelected = selectedClubs.contains(b)
            if aSelected && !bSelected { return true }
            if !aSelected && bSelected { return false }
            return (clubsForCategory.firstIndex(of: a) ?? 0) < (clubsForCategory.firstIndex(of: b) ?? 0)
        }
    }

    private var accentColor: Color { categoryAccentColor(for: category) }

    var body: some View {
        ZStack {
            NeoFuturisticTheme.slateBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                topBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        categorySection
                        nicknameSection
                        imageSection
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
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundStyle(Color(hex: "#8E97A6"))
                .accessibilityIdentifier("btn_cancel_add_block")

            Spacer()

            Text("New Block")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundStyle(Color.white)
                .hudTracking(0.5)

            Spacer()

            Button("Save") { saveBlock() }
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundStyle(name.isEmpty || selectedClubs.isEmpty ? Color(hex: "#4B5563") : Color(hex: "#2CE5A5"))
                .disabled(name.isEmpty || selectedClubs.isEmpty)
                .accessibilityIdentifier("btn_save_add_block")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Block Type")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 105))], spacing: 10) {
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
                            .font(.system(size: 12, weight: .semibold, design: .default))
                            .foregroundStyle(isSelected ? Color.white : Color(hex: "#8E97A6"))
                            .frame(height: 44).frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(isSelected ? catColor.opacity(0.18) : Color(hex: "#232836")))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(isSelected ? catColor : Color.white.opacity(0.06), lineWidth: 1.0))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nickname")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            TextField("e.g. Titleist T300", text: $name)
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundStyle(Color.white)
                .tint(accentColor)
                .padding(.horizontal, 16).padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#252A38")))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(name.isEmpty ? Color.white.opacity(0.08) : accentColor.opacity(0.5), lineWidth: 1.0))
        }
    }

    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Block Image (Icon)")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            Button(action: { /* Photo picker hook */ }) {
                HStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(accentColor)
                    Text("Select Image...")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundStyle(Color(hex: "#8E97A6"))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(Color(hex: "#64748B"))
                }
                .padding(.horizontal, 16).padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#252A38")))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1.0))
            }
            .buttonStyle(.plain)
        }
    }

    private var clubsAndYardagesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Clubs & Yardages")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            VStack(spacing: 10) {
                ForEach(sortedClubsForCategory, id: \.self) { club in
                    let isSelected = selectedClubs.contains(club)
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                if isSelected { selectedClubs.remove(club) } else { selectedClubs.insert(club) }
                            }
                        }) {
                            Text(club)
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundStyle(isSelected ? Color.white : Color(hex: "#8E97A6"))
                                .frame(width: 76, height: 44)
                                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(isSelected ? accentColor.opacity(0.2) : Color(hex: "#232836")))
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(isSelected ? accentColor : Color.white.opacity(0.06), lineWidth: 1.0))
                        }
                        .buttonStyle(.plain)

                        let binding = Binding<String>(
                            get: { yardages[club] ?? "" },
                            set: { yardages[club] = $0 }
                        )

                        TextField("Yardage", text: binding)
                            .keyboardType(.numberPad)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundStyle(isSelected ? Color.white : Color(hex: "#64748B"))
                            .tint(accentColor)
                            .padding(.horizontal, 12)
                            .frame(width: 95, height: 44)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: "#252A38")))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(isSelected ? accentColor.opacity(0.4) : Color.white.opacity(0.06), lineWidth: 1.0))
                            .disabled(!isSelected)

                        Text("Yds")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundStyle(isSelected ? Color(hex: "#8F9AA9") : Color(hex: "#64748B"))
                        Spacer()
                    }
                }
            }
        }
    }

    private func saveBlock() {
        viewModel.saveNewBlock(name: name, category: category, selectedClubs: selectedClubs, yardages: yardages)
        dismiss()
    }
}

// MARK: - EditBlockView

struct EditBlockView: View {
    @Environment(ClubsViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    let originalGroup: ClubGroup

    @State private var name: String
    @State private var selectedClubs: Set<String>
    @State private var yardages: [String: String]

    init(group: ClubGroup) {
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

    private var clubsForCategory: [String] {
        switch originalGroup.category {
        case "Driver":         return ["Driver"]
        case "Fairway Woodss": return ["3w", "5w", "7w", "9w"]
        case "Hybrid":         return ["3h", "4h", "5h", "6h"]
        case "Iron Set":       return ["3i", "4i", "5i", "6i", "7i", "8i", "9i", "PW"]
        case "Wedges":         return ["PW", "GW", "SW", "LW"]
        case "Putter":         return ["Putter"]
        default:               return []
        }
    }

    private var sortedClubsForCategory: [String] {
        clubsForCategory.sorted { a, b in
            let aSelected = selectedClubs.contains(a)
            let bSelected = selectedClubs.contains(b)
            if aSelected && !bSelected { return true }
            if !aSelected && bSelected { return false }
            return (clubsForCategory.firstIndex(of: a) ?? 0) < (clubsForCategory.firstIndex(of: b) ?? 0)
        }
    }

    private var accentColor: Color { categoryAccentColor(for: originalGroup.category) }

    var body: some View {
        ZStack {
            NeoFuturisticTheme.slateBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                topBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        nicknameSection
                        imageSection
                        clubsAndYardagesSection
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
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundStyle(Color(hex: "#8E97A6"))
                .accessibilityIdentifier("btn_cancel_edit_block")

            Spacer()

            Text("Edit Block")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundStyle(Color.white)
                .hudTracking(0.5)

            Spacer()

            Button("Save") { saveBlock() }
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundStyle(name.isEmpty || selectedClubs.isEmpty ? Color(hex: "#4B5563") : Color(hex: "#2CE5A5"))
                .disabled(name.isEmpty || selectedClubs.isEmpty)
                .accessibilityIdentifier("btn_save_edit_block")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nickname")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            TextField("e.g. Titleist T300", text: $name)
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundStyle(Color.white)
                .tint(accentColor)
                .padding(.horizontal, 16).padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#252A38")))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(name.isEmpty ? Color.white.opacity(0.08) : accentColor.opacity(0.5), lineWidth: 1.0))
        }
    }

    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Block Image (Icon)")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            Button(action: { /* Photo picker hook */ }) {
                HStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(accentColor)
                    Text("Select Image...")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundStyle(Color(hex: "#8E97A6"))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(Color(hex: "#64748B"))
                }
                .padding(.horizontal, 16).padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#252A38")))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1.0))
            }
            .buttonStyle(.plain)
        }
    }

    private var clubsAndYardagesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Clubs & Yardages")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(Color(hex: "#8F9AA9"))
                .hudTracking(0.8)

            VStack(spacing: 10) {
                ForEach(sortedClubsForCategory, id: \.self) { club in
                    let isSelected = selectedClubs.contains(club)
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                if isSelected { selectedClubs.remove(club) } else { selectedClubs.insert(club) }
                            }
                        }) {
                            Text(club)
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundStyle(isSelected ? Color.white : Color(hex: "#8E97A6"))
                                .frame(width: 76, height: 44)
                                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(isSelected ? accentColor.opacity(0.2) : Color(hex: "#232836")))
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(isSelected ? accentColor : Color.white.opacity(0.06), lineWidth: 1.0))
                        }
                        .buttonStyle(.plain)

                        let binding = Binding<String>(
                            get: { yardages[club] ?? "" },
                            set: { yardages[club] = $0 }
                        )

                        TextField("Yardage", text: binding)
                            .keyboardType(.numberPad)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundStyle(isSelected ? Color.white : Color(hex: "#64748B"))
                            .tint(accentColor)
                            .padding(.horizontal, 12)
                            .frame(width: 95, height: 44)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: "#252A38")))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(isSelected ? accentColor.opacity(0.4) : Color.white.opacity(0.06), lineWidth: 1.0))
                            .disabled(!isSelected)

                        Text("Yds")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundStyle(isSelected ? Color(hex: "#8F9AA9") : Color(hex: "#64748B"))
                        Spacer()
                    }
                }
            }
        }
    }

    private var deleteSection: some View {
        Button(action: deleteBlock) {
            HStack(spacing: 8) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 14, weight: .bold))
                Text("Delete Block")
                    .font(.system(size: 15, weight: .bold, design: .default))
            }
            .foregroundStyle(Color(hex: "#FF4554"))
            .frame(height: 48).frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#FF4554").opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(hex: "#FF4554").opacity(0.3), lineWidth: 1.0))
        }
        .accessibilityIdentifier("btn_delete_block")
        .buttonStyle(.plain)
        .padding(.top, 16)
    }

    private func saveBlock() {
        viewModel.saveEditedBlock(originalGroup: originalGroup, name: name, selectedClubs: selectedClubs, yardages: yardages)
        dismiss()
    }

    private func deleteBlock() {
        viewModel.deleteBlock(originalGroup)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    ClubsView()
        .environment(ClubsViewModel())
}
