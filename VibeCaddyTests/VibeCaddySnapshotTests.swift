//
//  VibeCaddySnapshotTests.swift
//  VibeCaddyTests
//
//  Snapshot testing suite with swift-snapshot-testing
//

import XCTest
import SwiftUI
import SwiftData
import SnapshotTesting
@testable import VibeCaddy

final class VibeCaddySnapshotTests: XCTestCase {
    
    static let sharedContainer: ModelContainer = {
        let schema = Schema([Club.self, Course.self, Hole.self, Round.self, Shot.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
        // isRecording = true
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    @MainActor
    func testPlayViewSnapshot() {
        let userVM = UserViewModel()
        let view = PlayView().environment(userVM)
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        assertSnapshot(of: vc, as: .image(drawHierarchyInKeyWindow: true))
    }

    @MainActor
    func testLeaderboardViewSnapshot() {
        let userVM = UserViewModel()
        let view = LeaderboardView().environment(userVM)
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        assertSnapshot(of: vc, as: .image(drawHierarchyInKeyWindow: true))
    }

    @MainActor
    func testClubsViewSnapshot() {
        let view = ClubsView().modelContainer(Self.sharedContainer)
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        assertSnapshot(of: vc, as: .image(drawHierarchyInKeyWindow: true))
    }

    @MainActor
    func testMainTabViewSnapshot() {
        let userVM = UserViewModel()
        let view = MainTabView(initialTab: .leaderboard)
            .environment(userVM)
            .modelContainer(Self.sharedContainer)
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 393, height: 852)
        assertSnapshot(of: vc, as: .image(drawHierarchyInKeyWindow: true))
    }
}
