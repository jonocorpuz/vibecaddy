//
//  UserDataService.swift
//  VibeCaddy
//

import Foundation

protocol UserDataServiceProtocol {
    func getUserProfile() -> UserProfile
    func saveUserProfile(_ profile: UserProfile)
}

final class UserDataService: UserDataServiceProtocol, UserProfileStorageProtocol {
    private let storage: UserProfileStorageProtocol

    init(storage: UserProfileStorageProtocol = UserDefaultsStorageService.shared) {
        self.storage = storage
    }

    // MARK: - UserDataServiceProtocol

    func getUserProfile() -> UserProfile {
        return storage.getProfile()
    }

    func saveUserProfile(_ profile: UserProfile) {
        storage.saveProfile(profile)
    }

    // MARK: - UserProfileStorageProtocol

    func getProfile() -> UserProfile {
        return storage.getProfile()
    }

    func saveProfile(_ profile: UserProfile) {
        storage.saveProfile(profile)
    }
}
