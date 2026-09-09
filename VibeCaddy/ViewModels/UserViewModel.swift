import Foundation
import SwiftUI

@Observable
final class UserViewModel {
    var profile: UserProfile {
        didSet {
            dataService.saveUserProfile(profile)
        }
    }
    
    private let dataService: UserDataServiceProtocol
    
    init(dataService: UserDataServiceProtocol = UserDataService()) {
        self.dataService = dataService
        self.profile = dataService.getUserProfile()
    }
}
