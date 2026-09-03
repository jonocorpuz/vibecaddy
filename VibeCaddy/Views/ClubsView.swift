import SwiftUI

struct ClubsView: View {
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: "seal.fill")
                                .font(.title2)
                                .foregroundColor(textBeige)
                            
                            Text("Inventory")
                                .font(.system(.largeTitle, design: .monospaced).bold())
                                .foregroundColor(textBeige)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 40)
                    
                    ClubCard(title: "Driver", distance: "250 yds")
                    ClubCard(title: "7 Iron", distance: "165 yds")
                    ClubCard(title: "Putter", distance: "--- yds")
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct ClubCard: View {
    let title: String
    let distance: String
    
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(textBeige)
                
                Text(distance)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(textBeige.opacity(0.7))
            }
            Spacer()
            
            Image(systemName: "seal.fill")
                .foregroundColor(textBeige)
                .font(.title2)
        }
        .padding()
        .background(cardDark)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(textBeige.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 30)
    }
}

#Preview {
    ClubsView()
}
