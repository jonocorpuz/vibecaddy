import Foundation
import SwiftData
import SwiftUI

@Observable
final class ClubsViewModel {
    
    // Group clubs for display in the UI
    func groupClubs(_ clubs: [Club]) -> [ClubGroup] {
        let dict = Dictionary(grouping: clubs) { club in
            ClubGroupKey(name: club.name, category: club.blockCategory ?? category(for: club.type))
        }
        
        return dict.map { key, grouped in
            ClubGroup(
                name: key.name,
                category: key.category,
                clubs: grouped.sorted(by: { ($0.averageDistance ?? 0) > ($1.averageDistance ?? 0) })
            )
        }.sorted { g1, g2 in
            let order = ["Driver": 0, "Fairway Woodss": 1, "Hybrid": 2, "Iron Set": 3, "Wedges": 4, "Putter": 5]
            let o1 = order[g1.category] ?? 99
            let o2 = order[g2.category] ?? 99
            if o1 != o2 { return o1 < o2 }
            return g1.name < g2.name
        }
    }
    
    private func category(for type: String) -> String {
        if type == "Driver" || type == "Putter" { return type }
        if type.hasSuffix("w") { return "Fairway Woodss" }
        if type.hasSuffix("h") { return "Hybrid" }
        if type.hasSuffix("i") { return "Iron Set" }
        if ["PW", "GW", "SW", "LW"].contains(type) { return "Wedges" }
        return "Club"
    }
    
    func seedDataIfNeeded(context: ModelContext, currentClubs: [Club]) {
        let defaultClubs = [
            Club(name: "Taylormade M4 9.5", type: "Driver", averageDistance: 250, blockCategory: "Driver"),
            Club(name: "Callaway AI Smoke Max", type: "3w", averageDistance: 220, blockCategory: "Fairway Woodss"),
            Club(name: "Taylormade M4", type: "3h", averageDistance: 200, blockCategory: "Hybrid"),
            Club(name: "Titleist T300", type: "5i", averageDistance: 180, blockCategory: "Iron Set"),
            Club(name: "Titleist T300", type: "7i", averageDistance: 155, blockCategory: "Iron Set"),
            Club(name: "Titleist T300", type: "9i", averageDistance: 130, blockCategory: "Iron Set"),
            Club(name: "Titleist Vokey SM10", type: "GW", averageDistance: 110, blockCategory: "Wedges"),
            Club(name: "Titleist Vokey SM10", type: "SW", averageDistance: 95, blockCategory: "Wedges"),
            Club(name: "LAB DF3i", type: "Putter", averageDistance: nil, blockCategory: "Putter")
        ]
        
        let existingNames = Set(currentClubs.map { $0.name })
        var didInsert = false
        
        for defaultClub in defaultClubs {
            if !existingNames.contains(defaultClub.name) {
                context.insert(defaultClub)
                didInsert = true
            }
        }
        
        if didInsert {
            try? context.save()
        }
    }
    
    func saveNewBlock(context: ModelContext, name: String, category: String, selectedClubs: Set<String>, yardages: [String: String]) {
        for clubType in selectedClubs {
            let distString = yardages[clubType] ?? ""
            let dist = Double(distString)
            let newClub = Club(name: name, type: clubType, averageDistance: dist, blockCategory: category)
            context.insert(newClub)
        }
        try? context.save()
    }
    
    func saveEditedBlock(context: ModelContext, originalGroup: ClubGroup, name: String, selectedClubs: Set<String>, yardages: [String: String]) {
        for club in originalGroup.clubs {
            if !selectedClubs.contains(club.type) {
                context.delete(club)
            } else {
                club.name = name
                let distString = yardages[club.type] ?? ""
                club.averageDistance = Double(distString)
            }
        }
        
        let existingTypes = Set(originalGroup.clubs.map { $0.type })
        for clubType in selectedClubs {
            if !existingTypes.contains(clubType) {
                let distString = yardages[clubType] ?? ""
                let dist = Double(distString)
                let newClub = Club(name: name, type: clubType, averageDistance: dist, blockCategory: originalGroup.category)
                context.insert(newClub)
            }
        }
        
        try? context.save()
    }
    
    func deleteBlock(context: ModelContext, originalGroup: ClubGroup) {
        for club in originalGroup.clubs {
            context.delete(club)
        }
        try? context.save()
    }
}
