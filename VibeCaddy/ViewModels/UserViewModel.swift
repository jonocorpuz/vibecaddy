import Foundation

@Observable
final class UserViewModel {

    var profile: UserProfile

    private let storage: UserProfileStorageProtocol

    init(storage: UserProfileStorageProtocol = UserDefaultsStorageService.shared) {
        self.storage = storage
        self.profile = storage.getProfile()
    }

    /// Updates the user's display name and persists it.
    func updateName(_ newName: String) {
        profile.name = newName
        storage.saveProfile(profile)
    }

    /// Updates the user's handicap and persists it.
    func updateHandicap(_ newHandicap: Double) {
        profile.handicap = newHandicap
        storage.saveProfile(profile)
    }
}
