# Project: VibeCaddy View-Model Integration & Local Persistence (Round 3)

## Architecture
VibeCaddy is a native iOS 17 AI golf caddy and rangefinder app built with SwiftUI and the `@Observable` framework.
The application architecture is strictly partitioned into:
- **Presentation Layer (`VibeCaddy/Views/`)**: SwiftUI views (`ContentView`, `MainTabView`, `PlayView`, `LeaderboardView`, `ClubsView`, `AddBlockView`, `EditBlockView`).
  - Strict Rule: Views contain ZERO direct `UserDefaults` calls and ZERO direct `ModelContext` / SwiftData calls. All interaction flows through ViewModels.
- **State & ViewModel Layer (`VibeCaddy/ViewModels/`)**: Coordinators observing state and managing user actions via `@Observable`.
  - `UserViewModel`: Injects `UserProfileStorageProtocol` to persist and mutate `UserProfile`.
  - `ClubsViewModel`: Owns `clubs: [Club]` and `clubGroups: [ClubGroup]`, injects `ClubStorageProtocol` for CRUD persistence.
  - `PlayViewModel`: Owns active round and telemetry state, injects `RoundStorageProtocol` and `MatchHistoryStorageProtocol` to record and complete rounds.
  - `LeaderboardViewModel`: Injects `LeaderboardStorageProtocol`, loads persisted match history, and dynamically computes statistics.
- **Storage & Persistence Layer (`VibeCaddy/Services/`)**: Abstracted persistence layer with protocol-based interface.
  - `StorageServiceProtocol`: Segregated protocols (`UserProfileStorageProtocol`, `ClubStorageProtocol`, `LeaderboardStorageProtocol`, `RoundStorageProtocol`).
  - `UserDefaultsStorageService`: Concrete implementation storing JSON-encoded data in `UserDefaults.standard` with automatic seeding on first launch.
  - Firebase-ready: Swapping `UserDefaultsStorageService` with `FirestoreStorageService` requires zero changes to ViewModels or Views.
- **Data Model Layer (`VibeCaddy/Models/`)**:
  - `UserProfile`: Codable value-type struct.
  - `ClubDTO`: Codable transfer object bridging `@Model Club` to/from JSON storage without macro serialization conflicts.
  - `MatchHistoryItem`: Codable, Equatable struct for match records.
  - `LeaderboardStats`: Codable struct for aggregate statistics.
  - `RoundRecord`: Codable struct for completed round records.
  - Existing SwiftData models (`Club`, `Course`, `Hole`, `Round`, `Shot`) preserved.
- **Theme & Component Layer (`VibeCaddy/Theme/`, `VibeCaddy/Components/`)**:
  - Reusable components (`FuturisticCard`, `NeonButton`, `HUDHeader`, `HexBadge`, `TacticalProgressBar`).
- **Test Infrastructure (`VibeCaddyTests/`)**:
  - Unit tests verifying `UserDefaultsStorageService`, ViewModel persistence, restart simulation, and view decoupling.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Storage Protocol Hierarchy | Define `StorageServiceProtocol` with segregated protocols (`UserProfileStorageProtocol`, `ClubStorageProtocol`, `LeaderboardStorageProtocol`, `RoundStorageProtocol`) | M1 | Survey (R2) |
| 2 | Codable DTOs & Models | Create `ClubDTO`, conform `MatchHistoryItem` to `Codable, Equatable`, define `LeaderboardStats` and `RoundRecord` | M1 | Survey (R2) |
| 3 | UserDefaults Storage Engine | Implement `UserDefaultsStorageService` with JSON encoding/decoding, key constants, and initial data seeding | M1 | Survey (R2) |
| 4 | Storage Backward Compatibility | Ensure `UserDataServiceProtocol` forwards to `UserDefaultsStorageService` to preserve compatibility | M1 | Survey (R2) |
| 5 | ClubsViewModel State & CRUD | Upgrade `ClubsViewModel` with stored `clubs`, `clubGroups`, `ClubStorageProtocol` injection, and CRUD methods without `ModelContext` | M2 | Survey (R1) |
| 6 | LeaderboardViewModel Dynamic Stats | Connect `LeaderboardViewModel` to `LeaderboardStorageProtocol`, load persisted history, implement dynamic `recalculateStats()` | M2 | Survey (R1) |
| 7 | PlayViewModel Round Lifecycle | Equip `PlayViewModel` with active round tracking, shot recording, and round completion persisting to match history | M2 | Survey (R1) |
| 8 | UserViewModel Mutation Helpers | Add `updateName` and `updateHandicap` helper methods to `UserViewModel` | M2 | Survey (R1) |
| 9 | ClubsView SwiftData Decoupling | Remove `@Environment(\.modelContext)` and `@Query` from `ClubsView`, `AddBlockView`, and `EditBlockView`, binding to `ClubsViewModel` | M3 | Survey (R1, R2) |
| 10 | PlayView HUD & Flow Integration | Connect Start Round CTA in `PlayView` to `PlayViewModel` with active round HUD, shot recording, and completion | M3 | Survey (R1) |
| 11 | Profile Edit Affordance | Provide user profile editing affordance in `PlayView` to allow testing live profile updates and persistence | M3 | Survey (R1) |
| 12 | LeaderboardView Dynamic Binding | Ensure `LeaderboardView` observes updated match history and recalculated stats dynamically on appear | M3 | Survey (R1) |
| 13 | Direct UserDefaults Absence Audit | Verify 0 direct calls to `UserDefaults` exist across all views in `VibeCaddy/Views/` | M3, M4 | Acceptance Criteria |
| 14 | Storage & ViewModel Unit Tests | Programmatic unit tests for storage CRUD, serialization, restart simulation, and ViewModel operations | M4 | Acceptance Criteria |
| 15 | Multi-Agent Review & Challenge Gate | Independent Reviewers, Challengers, and Forensic Auditor verification | M4 | Gate |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Storage Abstraction & Local Persistence Layer | Implement `StorageServiceProtocol`, `UserDefaultsStorageService`, `ClubDTO`, `MatchHistoryItem` Codable, `RoundRecord`, default data seeding, build verification | none | PLANNED |
| M2 | ViewModels Wiring & Business Logic Integration | Refactor `ClubsViewModel`, `LeaderboardViewModel`, `PlayViewModel`, `UserViewModel` to inject storage protocols, implement full CRUD and state transitions | M1 | PLANNED |
| M3 | View Integration & SwiftData Decoupling | Decouple `ClubsView`, `AddBlockView`, `EditBlockView` from SwiftData, wire `PlayView` active round & profile edit, ensure 0 direct UserDefaults calls in views | M2 | PLANNED |
| M4 | Comprehensive Verification, Testing & Audit Gate | Unit test suite in `VibeCaddyTests/StorageServiceTests.swift`, build & test verification, Challenger stress testing, Forensic Auditor integrity check | M3 | PLANNED |

## Interface Contracts

### Storage Layer ↔ ViewModels Contract
1. `UserProfileStorageProtocol`:
   - `func getProfile() -> UserProfile`
   - `func saveProfile(_ profile: UserProfile)`
2. `ClubStorageProtocol`:
   - `func getClubs() -> [Club]`
   - `func saveClubs(_ clubs: [Club])`
   - `func addClub(_ club: Club)`
   - `func updateClub(_ club: Club)`
   - `func deleteClub(id: UUID)`
3. `LeaderboardStorageProtocol`:
   - `func getMatchHistory() -> [MatchHistoryItem]`
   - `func saveMatchHistory(_ matches: [MatchHistoryItem])`
   - `func getLeaderboardStats() -> LeaderboardStats`
   - `func saveLeaderboardStats(_ stats: LeaderboardStats)`
4. `RoundStorageProtocol`:
   - `func getRounds() -> [RoundRecord]`
   - `func saveRounds(_ rounds: [RoundRecord])`
   - `func addRound(_ round: RoundRecord)`

### ViewModels ↔ Views Contract
1. `UserViewModel`:
   - `@Observable final class UserViewModel`
   - Properties: `var profile: UserProfile`
   - Methods: `func updateName(_ newName: String)`, `func updateHandicap(_ newHandicap: Double)`
2. `ClubsViewModel`:
   - `@Observable final class ClubsViewModel`
   - Properties: `var clubs: [Club]`, `var clubGroups: [ClubGroup]`
   - Methods: `func saveNewBlock(name: String, category: String, selectedClubs: Set<String>, yardages: [String: String])`, `func saveEditedBlock(originalGroup: ClubGroup, name: String, selectedClubs: Set<String>, yardages: [String: String])`, `func deleteBlock(originalGroup: ClubGroup)`, `func seedDataIfNeeded(context: ModelContext?, currentClubs: [Club]?)`
3. `PlayViewModel`:
   - `@Observable final class PlayViewModel`
   - Properties: `var weatherTemperature: String`, `var weatherIcon: String`, `var windSpeed: String`, `var windIcon: String`, `var isRoundActive: Bool`, `var currentHoleNumber: Int`, `var currentPar: Int`, `var currentDistanceToPin: Int`, `var strokesThisHole: Int`, `var totalScore: Int`
   - Methods: `func startRound()`, `func recordShot(club: String, distance: Double)`, `func advanceHole()`, `func finishRound() -> MatchHistoryItem?`, `func cancelRound()`
4. `LeaderboardViewModel`:
   - `@Observable final class LeaderboardViewModel`
   - Properties: `var matchHistory: [MatchHistoryItem]`, `var peakHandicap: Double`, `var last5RoundsHandicap: Double`, `var averageBirdies: String`, `var averagePars: String`, `var averageBogeys: String`, `var averageDoubleBogeysPlus: String`
   - Methods: `func loadHistory()`, `func addMatch(_ item: MatchHistoryItem)`, `func deleteMatch(id: UUID)`, `func recalculateStats()`

## Code Layout
```
VibeCaddy/
├── App/
│   └── VibeCaddyApp.swift
├── ContentView.swift
├── Theme/
│   ├── NeoFuturisticTheme.swift
│   ├── GlassmorphicStyle.swift
│   └── TacticalShapes.swift
├── Components/
│   ├── FuturisticCard.swift
│   ├── NeonButton.swift
│   ├── HUDHeader.swift
│   ├── HexBadge.swift
│   ├── TacticalProgressBar.swift
│   └── TelemetryTile.swift
├── Views/
│   ├── MainTabView.swift
│   ├── PlayView.swift                 # Wired to PlayViewModel (active round HUD & profile edit)
│   ├── LeaderboardView.swift          # Wired to LeaderboardViewModel (dynamic combat log & stats)
│   └── ClubsView.swift                # Decoupled from SwiftData, wired to ClubsViewModel
├── Models/
│   ├── Club.swift                     # SwiftData @Model preserved
│   ├── ClubDTO.swift                  # Codable DTO for storage serialization
│   ├── Course.swift                   # SwiftData @Model preserved
│   ├── Hole.swift                     # SwiftData @Model preserved
│   ├── Round.swift                    # SwiftData @Model preserved
│   ├── RoundRecord.swift              # Codable round summary
│   ├── Shot.swift                     # SwiftData @Model preserved
│   └── UserProfile.swift              # Codable value-type struct
├── ViewModels/
│   ├── ClubsViewModel.swift           # State owner for clubs, delegates to ClubStorageProtocol
│   ├── LeaderboardViewModel.swift     # State owner for rankings, delegates to LeaderboardStorageProtocol
│   ├── PlayViewModel.swift            # State owner for round flow, delegates to StorageServiceProtocol
│   └── UserViewModel.swift            # State owner for profile, delegates to UserProfileStorageProtocol
├── Services/
│   ├── StorageServiceProtocol.swift   # Abstracted domain storage protocols
│   ├── UserDefaultsStorageService.swift # Local persistence engine via UserDefaults
│   └── UserDataService.swift          # Forwarding compatibility layer
└── VibeCaddyTests/
    ├── ClubsAndLeaderboardViewTests.swift
    ├── NavigationAndPlayViewTests.swift
    └── StorageServiceTests.swift      # Unit tests for persistence, restarts, and view decoupling
```
