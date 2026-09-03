import SwiftUI
import MapKit

struct PlayView: View {
    let bgDark = Color(red: 0.10, green: 0.08, blue: 0.07)
    let textBeige = Color(red: 0.86, green: 0.81, blue: 0.71)
    
    var body: some View {
        ZStack {
            bgDark.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("VibeCaddy")
                    .font(.system(.title, design: .monospaced).bold())
                    .foregroundColor(textBeige)
                    .padding(.top, 20)
                
                // Map encased in a container
                Map()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxHeight: 450)
                    .padding(.horizontal, 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(textBeige.opacity(0.3), lineWidth: 2)
                            .padding(.horizontal, 30)
                    )
                
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
                
                Spacer()
            }
        }
    }
}

#Preview {
    PlayView()
}
