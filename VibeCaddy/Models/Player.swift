import Foundation
import SwiftData

@Model
final class Player {
    var id: UUID
    var name: String
    var handicap: Double?
    
    @Relationship(deleteRule: .cascade, inverse: \Club.player)
    var clubs: [Club]?
    
    init(id: UUID = UUID(), name: String, handicap: Double? = nil) {
        self.id = id
        self.name = name
        self.handicap = handicap
    }
}
