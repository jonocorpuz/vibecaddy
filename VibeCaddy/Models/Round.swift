import Foundation
import SwiftData

@Model
final class Round {
    var id: UUID
    var date: Date
    var course: Course?
    
    @Relationship(deleteRule: .cascade, inverse: \Shot.round)
    var shots: [Shot]?
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
}
