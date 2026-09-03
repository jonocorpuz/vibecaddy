import SwiftUI

struct ClubsView: View {
    var body: some View {
        ZStack {
            Color(white: 0.08).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text("My Clubs")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ClubCard(title: "Driver", distance: "250 yds", color: Color(red: 0.8, green: 0.95, blue: 0.9))
                    ClubCard(title: "7 Iron", distance: "165 yds", color: Color(red: 0.95, green: 0.85, blue: 0.9))
                    ClubCard(title: "Putter", distance: "N/A", color: Color(red: 0.95, green: 0.9, blue: 0.8))
                }
                .padding(.bottom, 24)
            }
        }
    }
}

struct ClubCard: View {
    let title: String
    let distance: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(distance)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
            }
            Spacer()
            
            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "circle.grid.cross.fill")
                        .foregroundColor(.black)
                )
        }
        .padding()
        .background(color)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

#Preview {
    ClubsView()
}
