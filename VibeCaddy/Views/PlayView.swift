import SwiftUI
import MapKit

struct PlayView: View {
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Ready to Play?")
                    .font(.system(.title, design: .monospaced).bold())
                    .foregroundColor(textBeige)
                    .padding(.top, 20)
                
                // Map encased in a container
                Map()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxHeight: 350)
                    .padding(.horizontal, 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(textBeige.opacity(0.3), lineWidth: 2)
                            .padding(.horizontal, 30)
                    )
                
                // Weather & Wind Containers
                HStack(spacing: 16) {
                    InfoCard(title: "WEATHER", value: "72°", icon: "sun.max.fill")
                    InfoCard(title: "WIND", value: "5 MPH", icon: "wind")
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    // Play action to be implemented
                }) {
                    Text("START ROUND")
                        .font(.system(.title3, design: .monospaced).bold())
                        .foregroundColor(bgDark)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(textBeige)
                        .cornerRadius(12)
                        .padding(.horizontal, 50)
                }
                
                Spacer(minLength: 20)
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    let cardDark = Color(red: 0.14, green: 0.12, blue: 0.11)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(.caption, design: .monospaced))
            .foregroundColor(textBeige.opacity(0.7))
            
            Text(value)
                .font(.system(.title2, design: .monospaced).bold())
                .foregroundColor(textBeige)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(cardDark)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(textBeige.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    PlayView()
}
