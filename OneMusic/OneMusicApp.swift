//
//  OneMusicApp.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/10.
//

import SwiftUI

@main
struct OneMusicApp: App {
    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                MainTabView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
