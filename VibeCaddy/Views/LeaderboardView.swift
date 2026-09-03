import SwiftUI

struct LeaderboardView: View {
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Image(systemName: "seal.fill")
                        .font(.title2)
                        .foregroundColor(textBeige)
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 16)
                
                HStack {
                    Text("Rankings")
                        .font(.system(.largeTitle, design: .monospaced).bold())
                        .foregroundColor(textBeige)
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

#Preview {
    LeaderboardView()
}
