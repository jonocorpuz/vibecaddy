import SwiftUI
import SwiftData

@main
struct VibeCaddyApp: App {

    // Shared ViewModels — created once and injected down the view tree
    @State private var userViewModel = UserViewModel()
    @State private var clubsViewModel = ClubsViewModel()

    // SwiftData container — kept for Course, Hole, Round, Shot models
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Course.self,
            Hole.self,
            Round.self,
            Shot.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userViewModel)
                .environment(clubsViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
