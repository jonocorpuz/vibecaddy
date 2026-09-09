import SwiftUI
import SwiftData

struct ClubGroupKey: Hashable {
    let name: String
    let category: String
}

struct ClubGroup: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let clubs: [Club]
}

struct ClubsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var clubs: [Club]
    @State private var viewModel = ClubsViewModel()
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        NavigationStack {
            ZStack {
                bgDark.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundColor(textBeige)
                            .frame(width: 40, height: 40)
                            .background(cardDark)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(textBeige.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Inventory")
                                    .font(.system(.largeTitle, design: .monospaced).bold())
                                    .foregroundColor(textBeige)
                                Spacer()
                                NavigationLink(destination: AddBlockView(viewModel: viewModel).navigationBarBackButtonHidden(true)) {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(textBeige)
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 24)
                            
                            ForEach(viewModel.groupClubs(clubs)) { group in
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
                        .padding(.bottom, 30)
                    }
                }
            }
            .onAppear {
                viewModel.seedDataIfNeeded(context: modelContext, currentClubs: clubs)
            }
        }
    }
}

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
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(textBeige.opacity(0.7))
                    Spacer()
                    Text("New Block")
                        .font(.system(.headline, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                    Spacer()
                    Button("Save") { saveBlock() }
                        .font(.system(.body, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                        .disabled(name.isEmpty || selectedClubs.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Block Type")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                                ForEach(categories, id: \.self) { cat in
                                    let isSelected = category == cat
                                    Button(action: {
                                        if category != cat {
                                            category = cat
                                            withAnimation {
                                                selectedClubs.removeAll()
                                                yardages.removeAll()
                                            }
                                        }
                                    }) {
                                        Text(cat)
                                            .font(.system(.footnote, design: .monospaced).bold())
                                            .foregroundColor(isSelected ? bgDark : textBeige)
                                            .frame(height: 50)
                                            .frame(maxWidth: .infinity)
                                            .background(isSelected ? textBeige : cardDark)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(textBeige.opacity(isSelected ? 1 : 0.3), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nickname")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                                
                            TextField("e.g. Titleist T300", text: $name)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(textBeige)
                                .tint(textBeige)
                                .padding()
                                .background(cardDark)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(textBeige.opacity(0.3), lineWidth: 1))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Block Image (Icon)")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                                
                            Button(action: {
                                // TODO: Implement Photo Picker
                            }) {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                    Text("Select Image...")
                                    Spacer()
                                }
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(textBeige.opacity(0.7))
                                .padding()
                                .background(cardDark)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(textBeige.opacity(0.3), lineWidth: 1))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Clubs & Yardages")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                            
                            VStack(spacing: 12) {
                                ForEach(sortedClubsForCategory, id: \.self) { club in
                                    let isSelected = selectedClubs.contains(club)
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            withAnimation {
                                                if isSelected {
                                                    selectedClubs.remove(club)
                                                } else {
                                                    selectedClubs.insert(club)
                                                }
                                            }
                                        }) {
                                            Text(club)
                                                .font(.system(.body, design: .monospaced).bold())
                                                .foregroundColor(isSelected ? bgDark : textBeige)
                                                .frame(width: 80, height: 50)
                                                .background(isSelected ? textBeige : cardDark)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(textBeige.opacity(isSelected ? 1 : 0.3), lineWidth: 1)
                                                )
                                        }
                                        
                                        let binding = Binding<String>(
                                            get: { yardages[club] ?? "" },
                                            set: { yardages[club] = $0 }
                                        )
                                        
                                        TextField("Yardage", text: binding)
                                            .keyboardType(.numberPad)
                                            .font(.system(.body, design: .monospaced))
                                            .foregroundColor(isSelected ? textBeige : Color.gray)
                                            .tint(textBeige)
                                            .padding(.horizontal)
                                            .frame(width: 100, height: 50)
                                            .background(cardDark)
                                            .cornerRadius(12)
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? textBeige.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1))
                                            .disabled(!isSelected)
                                        
                                        Text("Yds")
                                            .font(.system(.caption, design: .monospaced).bold())
                                            .foregroundColor(isSelected ? textBeige.opacity(0.7) : Color.gray)
                                            
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func saveBlock() {
        viewModel.saveNewBlock(context: modelContext, name: name, category: category, selectedClubs: selectedClubs, yardages: yardages)
        dismiss()
    }
}

struct ClubBlockCard: View {
    let name: String
    let category: String
    let clubs: [Club]
    
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(.headline, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                    Text(category)
                        .font(.system(.caption, design: .monospaced).bold())
                        .foregroundColor(textBeige.opacity(0.5))
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                // Single blank image/squircle right of the title
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.20, green: 0.18, blue: 0.17))
                }
                .frame(width: 44, height: 44)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(clubs) { club in
                    let distanceStr = club.averageDistance != nil ? "\(Int(club.averageDistance!)) yds" : "--- yds"
                    Text("\(club.type) • \(distanceStr)")
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(textBeige.opacity(0.8))
                }
            }
        }
        .padding()
        .background(cardDark)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(textBeige.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 30)
    }
}

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
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(textBeige.opacity(0.7))
                    Spacer()
                    Text("Edit Block")
                        .font(.system(.headline, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                    Spacer()
                    Button("Save") { saveBlock() }
                        .font(.system(.body, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                        .disabled(name.isEmpty || selectedClubs.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nickname")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                                
                            TextField("e.g. Titleist T300", text: $name)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(textBeige)
                                .tint(textBeige)
                                .padding()
                                .background(cardDark)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(textBeige.opacity(0.3), lineWidth: 1))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Block Image (Icon)")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                                
                            Button(action: {
                                // TODO: Implement Photo Picker
                            }) {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                    Text("Select Image...")
                                    Spacer()
                                }
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(textBeige.opacity(0.7))
                                .padding()
                                .background(cardDark)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(textBeige.opacity(0.3), lineWidth: 1))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Clubs & Yardages")
                                .font(.system(.caption, design: .monospaced).bold())
                                .foregroundColor(textBeige.opacity(0.7))
                            
                            VStack(spacing: 12) {
                                ForEach(sortedClubsForCategory, id: \.self) { club in
                                    let isSelected = selectedClubs.contains(club)
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            withAnimation {
                                                if isSelected {
                                                    selectedClubs.remove(club)
                                                } else {
                                                    selectedClubs.insert(club)
                                                }
                                            }
                                        }) {
                                            Text(club)
                                                .font(.system(.body, design: .monospaced).bold())
                                                .foregroundColor(isSelected ? bgDark : textBeige)
                                                .frame(width: 80, height: 50)
                                                .background(isSelected ? textBeige : cardDark)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(textBeige.opacity(isSelected ? 1 : 0.3), lineWidth: 1)
                                                )
                                        }
                                        
                                        let binding = Binding<String>(
                                            get: { yardages[club] ?? "" },
                                            set: { yardages[club] = $0 }
                                        )
                                        
                                        TextField("Yardage", text: binding)
                                            .keyboardType(.numberPad)
                                            .font(.system(.body, design: .monospaced))
                                            .foregroundColor(isSelected ? textBeige : Color.gray)
                                            .tint(textBeige)
                                            .padding(.horizontal)
                                            .frame(width: 100, height: 50)
                                            .background(cardDark)
                                            .cornerRadius(12)
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? textBeige.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1))
                                            .disabled(!isSelected)
                                        
                                        Text("Yds")
                                            .font(.system(.caption, design: .monospaced).bold())
                                            .foregroundColor(isSelected ? textBeige.opacity(0.7) : Color.gray)
                                            
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            deleteBlock()
                        }) {
                            Text("Delete Block")
                                .font(.system(.body, design: .monospaced).bold())
                                .foregroundColor(.red)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.3), lineWidth: 1))
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
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

#Preview {
    ClubsView()
        .modelContainer(for: Club.self, inMemory: true)
}
