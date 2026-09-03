import SwiftUI
import MapKit

struct PlayView: View {
    var body: some View {
        ZStack {
            Color(white: 0.08).ignoresSafeArea()
            
            Map()
                .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                
                Button(action: {
                    // Play action to be implemented
                }) {
                    HStack {
                        Image(systemName: "flag.circle.fill")
                            .font(.title2)
                        Text("Play")
                            .font(.title2.bold())
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.8, green: 0.95, blue: 0.9))
                    .cornerRadius(20)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    PlayView()
}
