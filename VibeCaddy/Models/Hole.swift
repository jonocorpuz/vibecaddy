import Foundation
import SwiftData

@Model
final class Hole {
    var id: UUID
    var number: Int
    var par: Int
    var handicapIndex: Int?
    var distance: Int?
    var course: Course?
    
    init(id: UUID = UUID(), number: Int, par: Int, handicapIndex: Int? = nil, distance: Int? = nil) {
        self.id = id
        self.number = number
        self.par = par
        self.handicapIndex = handicapIndex
        self.distance = distance
    }
}
