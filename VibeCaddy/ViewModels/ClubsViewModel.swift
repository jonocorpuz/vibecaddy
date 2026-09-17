import Foundation

@Observable
final class ClubsViewModel {

    // MARK: - State

    /// The flat list of all clubs, loaded from storage.
    var clubs: [Club] = []

    private let storage: ClubStorageProtocol

    // MARK: - Init

    init(storage: ClubStorageProtocol = UserDefaultsStorageService.shared) {
        self.storage = storage
        self.clubs = storage.getClubs()
    }

    // MARK: - Grouping

    /// Groups the flat clubs array into display-ready ClubGroups, sorted by category.
    var clubGroups: [ClubGroup] {
        groupClubs(clubs)
    }

    private func groupClubs(_ clubs: [Club]) -> [ClubGroup] {
        let dict = Dictionary(grouping: clubs) { club in
            ClubGroupKey(name: club.name, category: club.blockCategory ?? category(for: club.type))
        }

        return dict.map { key, grouped in
            ClubGroup(
                name: key.name,
                category: key.category,
                clubs: grouped.sorted { ($0.averageDistance ?? 0) > ($1.averageDistance ?? 0) }
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

    // MARK: - CRUD

    /// Adds a new club block (one Club per selected club type) and persists it.
    func saveNewBlock(name: String, category: String, selectedClubs: Set<String>, yardages: [String: String]) {
        for clubType in selectedClubs {
            let distance = Double(yardages[clubType] ?? "")
            let newClub = Club(name: name, type: clubType, averageDistance: distance, blockCategory: category)
            clubs.append(newClub)
        }
        storage.saveClubs(clubs)
    }

    /// Updates an existing block: removes de-selected clubs, updates distances, adds new ones.
    func saveEditedBlock(originalGroup: ClubGroup, name: String, selectedClubs: Set<String>, yardages: [String: String]) {
        // Remove clubs that were de-selected
        clubs.removeAll { club in
            originalGroup.clubs.contains(where: { $0.id == club.id }) && !selectedClubs.contains(club.type)
        }

        // Update clubs that remain
        for i in clubs.indices {
            if originalGroup.clubs.contains(where: { $0.id == clubs[i].id }) {
                clubs[i].name = name
                clubs[i].averageDistance = Double(yardages[clubs[i].type] ?? "")
            }
        }

        // Add new club types not previously in the block
        let existingTypes = Set(originalGroup.clubs.map { $0.type })
        for clubType in selectedClubs where !existingTypes.contains(clubType) {
            let distance = Double(yardages[clubType] ?? "")
            let newClub = Club(name: name, type: clubType, averageDistance: distance, blockCategory: originalGroup.category)
            clubs.append(newClub)
        }

        storage.saveClubs(clubs)
    }

    /// Deletes all clubs belonging to a group and persists the change.
    func deleteBlock(_ group: ClubGroup) {
        let idsToRemove = Set(group.clubs.map { $0.id })
        clubs.removeAll { idsToRemove.contains($0.id) }
        storage.saveClubs(clubs)
    }
}
