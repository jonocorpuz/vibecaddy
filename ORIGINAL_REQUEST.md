# Original User Request

## Initial Request — 2026-09-09T00:07:06Z

# Teamwork Project Prompt — Draft

> Status: Launched
> Goal: Craft prompt → get user approval → delegate to teamwork_preview
> Requested team: [none — teamwork routes from the description]

Redesign the entire VibeCaddy iOS app (an AI golf caddy and rangefinder) to adopt a gamified, "Valorant neo-futuristic" dark aesthetic targeted at younger golfers. The redesign must use SwiftUI and iOS 17 while preserving existing functionalities, models, and view models.

Working directory: /Users/jono/Documents/VibeCaddy
Integrity mode: development

## Requirements

### R1. Comprehensive Neo-Futuristic Redesign
Redesign all main views (`PlayView`, `LeaderboardView`, `ClubsView`, `ContentView`, `MainTabView`) to use a deep, OLED-friendly dark mode with high-contrast neon accents, glassmorphism, and geometric typography. Minimal use of well-known third-party Swift Packages is allowed if it saves time (e.g., for complex charts).

### R2. Preserve Existing Architecture and State
Do not alter the core data models (`Club`, `UserProfile`, `Course`, `Round`, etc.) or the underlying logic in the ViewModels. The redesign should strictly be a UI/UX update mapping to the existing state.

### R3. Micro-interactions and Animations
Implement fluid, physics-based micro-interactions and at least one signature morphing or spatial animation (using `.phaseAnimator` or matched geometry) that elevates the futuristic feel.

### R4. Version Control and Standards
Create a new git branch for this redesign. Commit frequently with conventional commit messages. Follow standard Swift/SwiftUI engineering practices to ensure highly readable code.

### R5. Verification Implementation
Implement basic XCUITests to verify that all critical existing buttons and data fields are still present on the redesigned screens. Additionally, set up Snapshot Testing (`swift-snapshot-testing`) and generate snapshot references for the new screens to allow for manual visual review.

## Acceptance Criteria

### Aesthetic & UI
- [ ] All main views use a dark mode color palette with neon accents.
- [ ] Glassmorphic elements (translucent overlays, thin borders) are used in at least three main views.
- [ ] At least one advanced animation (`.phaseAnimator` or matched geometry) is implemented and functioning.

### Architecture & Stability
- [ ] The app compiles successfully without errors.
- [ ] No modifications were made to the core Data Models or ViewModels logic.
- [ ] The project is on a newly created git branch, with multiple conventional commits documenting the progress.

### Verification
- [ ] XCUITests pass, confirming the presence of all original functional UI elements (buttons, inputs, lists) on the redesigned screens.
- [ ] Snapshot tests are configured, and initial reference snapshots for all main views have been generated and committed.

## Follow-up — 2026-09-09T01:34:00Z

# Teamwork Project Prompt — Draft

> Status: Launched (Iteration 2)
> Goal: Craft prompt → get user approval → delegate to teamwork_preview
> Requested team: [none — teamwork routes from the description]

Redesign the VibeCaddy iOS app (AI golf caddy) to have a highly premium, modern, and clean "Valorant neo" aesthetic. The previous iteration was too "tacky" and cheap; this iteration must look expensive and sleek.

Working directory: /Users/jono/Documents/VibeCaddy
Integrity mode: development

## Requirements

### R1. Premium Neo-Futuristic Aesthetics (MATCH REFERENCE)
The design MUST exactly mimic the provided premium reference image. Do not make it overly glowing or cheap. 
*   **Colors**: Use a deep slate/navy background (e.g., `#1A1C23`). Use clean, muted gradients (magenta/purple) for primary accents, and subtle cyan/teal for data highlights.
*   **Containers**: Use clean cards with smooth rounded corners, very subtle inner borders (1px semi-transparent white/grey), and solid or very lightly frosted backgrounds. Avoid excessive blur.
*   **Typography**: Use a highly readable, modern, clean sans-serif font. Use uppercase, slightly stylized fonts strictly for headers, and clean text for data.

### R2. Preserve Architecture
Maintain strict immutability of the core data models (`Club`, `UserProfile`, `Course`, `Round`, etc.) and ViewModels. This is purely a UI/UX update mapping to existing state.

### R3. Expedited Execution (Minimal Testing)
To expedite the process, skip all Snapshot Testing (`swift-snapshot-testing`). Do not write extensive XCUITests. Focus entirely on rapid, high-quality UI implementation. Basic build verification is sufficient.

### R4. Version Control
Create a new branch (e.g., `feature/neo-premium-redesign`) from `main` or reset the previous work to start fresh with this premium aesthetic.

## Acceptance Criteria

### Aesthetic & UI
- [ ] UI exactly matches the color palette (slate/navy backgrounds, magenta/purple gradients, cyan highlights) of the reference.
- [ ] Containers use clean, premium rounded corners with subtle 1px borders, avoiding tacky/excessive neon glows.
- [ ] Typography is clean, modern, and highly legible.

### Architecture & Stability
- [ ] The app compiles successfully.
- [ ] Core Data Models and ViewModels are completely unmodified.

### Verification (Expedited)
- [ ] The project builds without errors. (No snapshot tests or XCUITests required).

## Follow-up — 2026-09-09T16:46:57Z

# Teamwork Project Prompt — Draft

> Status: Launched
> Goal: Craft prompt → get user approval → delegate to teamwork_preview
> Requested team: [none — teamwork routes from the description]

Wire up the existing views and models across the entire VibeCaddy app using ViewModels. Ensure data persists locally and the app is fully usable end-to-end, without overhauling the current architecture.

Working directory: /Users/jono/Documents/VibeCaddy
Integrity mode: development

## Requirements

### R1. View-Model Integration
Connect all existing views to their respective models so the app functions completely. Do not perform a major architectural overhaul; simply connect the existing pipes. Prioritize readable, easy-to-understand code above all else.

### R2. Local Persistence
Persist all core app data locally so it survives application restarts. Use UserDefaults for this implementation, but abstract the storage layer so it can smoothly transition to Firebase database and authentication in the future.

## Acceptance Criteria

### Functionality & Verification
- [ ] The app compiles and runs locally without build errors.
- [ ] Data modified in the app is successfully written to and read from UserDefaults (verifiable via programmatic unit tests or an agent-as-judge reviewing the data flow).
- [ ] Application state persists successfully across app restarts.
- [ ] Views contain no direct UserDefaults storage logic, adhering to the requirement for abstraction.

