//
//  SparkAppApp.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 22.11.2025.
//

import SwiftUI

@main
struct SparkAppApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .onAppear {
                    DispatchQueue.main.async {
                        KeyboardWarmup.warmupInBackground()
                    }
                }
                .preferredColorScheme(.light)
        }
    }
}
