import SwiftUI

struct LeaderboardView: View {
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            Text("Rankings")
                .font(.system(.largeTitle, design: .monospaced).bold())
                .foregroundColor(textBeige)
        }
    }
}

#Preview {
    LeaderboardView()
}
