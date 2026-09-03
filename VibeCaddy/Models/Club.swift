import Foundation
import SwiftData

@Model
final class Club {
    var id: UUID
    var name: String
    var type: String
    var averageDistance: Double?
    var player: Player?
    
    init(id: UUID = UUID(), name: String, type: String, averageDistance: Double? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.averageDistance = averageDistance
    }
}
