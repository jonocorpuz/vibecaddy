import Foundation
import SwiftUI

@Observable
final class PlayViewModel {
    var weatherTemperature: String = "72°"
    var weatherIcon: String = "sun.max.fill"
    var windSpeed: String = "5 MPH"
    var windIcon: String = "wind"
    
    // Abstracting out the play action
    func startRound() {
        print("Starting round...")
    }
}
