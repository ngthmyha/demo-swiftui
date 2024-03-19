//
//  Animation01App.swift
//  Animation01
//
//  Created by MacMini4 on 14/03/2024.
//

import SwiftUI

@main
struct Animation01App: App {
    @State private var isLaunch = true
    var body: some Scene {
        WindowGroup {
            if isLaunch {
                LaunchScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                            self.isLaunch = false
                        })
                    }
            } else {
                ContentView()
            }
        }
    }
}
