//
//  HelloTextKitApp.swift
//  HelloTextKit
//
//  Created by Kyuhyun Park on 2/16/26.
//

import SwiftUI

@main
struct HelloTextKitApp: App {
    @State private var settings = SettingsModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
        }
        Settings {
            SettingsView()
                .environment(settings)
        }
    }
}

