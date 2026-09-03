import SwiftUI

struct LeaderboardView: View {
    var body: some View {
        ZStack {
            Color(white: 0.08).ignoresSafeArea()
            
            Text("Leaderboard")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
    }
}

#Preview {
    LeaderboardView()
}
