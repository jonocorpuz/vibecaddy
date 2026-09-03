import SwiftUI
import SwiftData

struct ClubsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var clubs: [Club]
    
    @State private var showingAddClub = false
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
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
                            Button(action: { showingAddClub = true }) {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(textBeige)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 24)
                        
                        ForEach(clubs.sorted(by: { ($0.averageDistance ?? 0) > ($1.averageDistance ?? 0) })) { club in
                            ClubCard(
                                title: club.name,
                                distance: club.averageDistance != nil ? "\(Int(club.averageDistance!)) yds" : "--- yds"
                            )
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            seedDataIfNeeded()
        }
        .sheet(isPresented: $showingAddClub) {
            AddClubView()
        }
    }
    
    private func seedDataIfNeeded() {
        let defaultClubs = [
            Club(name: "Driver", type: "Wood", averageDistance: 230),
            Club(name: "7 Wood", type: "Wood", averageDistance: 190),
            Club(name: "5 Iron", type: "Iron", averageDistance: 170),
            Club(name: "7 Iron", type: "Iron", averageDistance: 145),
            Club(name: "9 Iron", type: "Iron", averageDistance: 120),
            Club(name: "50° Gap Wedge", type: "Wedge", averageDistance: 105),
            Club(name: "54° Sand Wedge", type: "Wedge", averageDistance: 95)
        ]
        
        let existingNames = Set(clubs.map { $0.name })
        var didInsert = false
        
        for defaultClub in defaultClubs {
            if !existingNames.contains(defaultClub.name) {
                modelContext.insert(defaultClub)
                didInsert = true
            }
        }
        
        if didInsert {
            try? modelContext.save()
        }
    }
}

struct AddClubView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var distance: String = ""
    
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 32) {
                HStack {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(textBeige.opacity(0.7))
                    Spacer()
                    Text("New Club")
                        .font(.system(.headline, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                    Spacer()
                    Button("Save") { saveClub() }
                        .font(.system(.body, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                        .disabled(name.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                VStack(spacing: 16) {
                    TextField("Club Name (e.g. 3 Wood)", text: $name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(textBeige)
                        .padding()
                        .background(cardDark)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(textBeige.opacity(0.3), lineWidth: 1))
                    
                    TextField("Average Distance (yds)", text: $distance)
                        .keyboardType(.numberPad)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(textBeige)
                        .padding()
                        .background(cardDark)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(textBeige.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    private func saveClub() {
        let dist = Double(distance)
        let newClub = Club(name: name, type: "Custom", averageDistance: dist)
        modelContext.insert(newClub)
        try? modelContext.save()
        dismiss()
    }
}

struct ClubCard: View {
    let title: String
    let distance: String
    
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(textBeige)
                
                Text(distance)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(textBeige.opacity(0.7))
            }
            Spacer()
            
            Image(systemName: "seal.fill")
                .foregroundColor(textBeige)
                .font(.title2)
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

#Preview {
    ClubsView()
        .modelContainer(for: Club.self, inMemory: true)
}
