import Foundation
import SwiftData

@Model
final class Shot {
    var id: UUID
    var holeNumber: Int
    var distance: Double
    var details: String?
    var club: Club?
    var round: Round?
    
    init(id: UUID = UUID(), holeNumber: Int, distance: Double, details: String? = nil) {
        self.id = id
        self.holeNumber = holeNumber
        self.distance = distance
        self.details = details
    }
}
