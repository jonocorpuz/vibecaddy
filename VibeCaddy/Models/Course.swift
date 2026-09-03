import Foundation
import SwiftData

@Model
final class Course {
    var id: UUID
    var name: String
    var location: String
    
    @Relationship(deleteRule: .cascade, inverse: \Hole.course)
    var holes: [Hole]?
    
    init(id: UUID = UUID(), name: String, location: String) {
        self.id = id
        self.name = name
        self.location = location
    }
}
