//
//  ContentView.swift
//  VibeCaddy
//
//  Created by Jonathan Corpuz on 2026-09-02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            NeoFuturisticTheme.slateBackground
                .ignoresSafeArea()
            
            MainTabView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environment(UserViewModel())
        .environment(ClubsViewModel())
}
