import Foundation

protocol UserDataServiceProtocol {
    func getUserProfile() -> UserProfile
    func saveUserProfile(_ profile: UserProfile)
}

final class UserDataService: UserDataServiceProtocol {
    private let defaults = UserDefaults.standard
    private let profileKey = "vibeCaddyUserProfile"
    
    func getUserProfile() -> UserProfile {
        if let data = defaults.data(forKey: profileKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return profile
        }
        // Default profile if none exists
        return UserProfile(name: "Jonathan", handicap: 12.4)
    }
    
    func saveUserProfile(_ profile: UserProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: profileKey)
        }
    }
}
