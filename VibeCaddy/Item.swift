//
//  Item.swift
//  VibeCaddy
//
//  Created by Jonathan Corpuz on 2026-09-02.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
