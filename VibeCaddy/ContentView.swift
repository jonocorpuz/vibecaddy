//
//  ContentView.swift
//  VibeCaddy
//
//  Created by Jonathan Corpuz on 2026-09-02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [Player]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(players) { player in
                    NavigationLink {
                        Text("Player: \(player.name)")
                    } label: {
                        Text(player.name)
                    }
                }
                .onDelete(perform: deletePlayers)
            }
            .navigationTitle("VibeCaddy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addPlayer) {
                        Label("Add Player", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a player")
        }
    }

    private func addPlayer() {
        withAnimation {
            let newPlayer = Player(name: "New Player")
            modelContext.insert(newPlayer)
        }
    }

    private func deletePlayers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(players[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Player.self, inMemory: true)
}
