//
//  HelloTextKitApp.swift
//  HelloTextKit
//
//  Created by Kyuhyun Park on 2/16/26.
//

import SwiftUI

@main
struct HelloTextKitApp: App {
    @State private var settings = AppSettings.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            SettingsView()
                .environment(settings)
        }
    }
}

