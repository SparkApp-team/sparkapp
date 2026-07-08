//
//  SparkAppApp.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 22.11.2025.
//

import SwiftUI

@main
struct SparkAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel(container: delegate.dependencies.container))
                .environment(delegate.dependencies.container)
        }
    }
}
