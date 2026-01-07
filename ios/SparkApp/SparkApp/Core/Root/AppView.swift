//
//  AppView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

struct AppView: View {
    @State var appState: AppState = AppState()
    
    var body: some View {
        AppViewBuilder(
            option: appState.option,
            launch: {
                SplashView()
            },
            auth: {
                LoginView()
            },
            content: {
                HabitsView()
            }
        )
        .environment(appState)
    }
}

#Preview("Launch") {
    AppView(appState: AppState(option: .launch))
}

#Preview("Auth") {
    AppView(appState: AppState(option: .auth))
}

#Preview("Content") {
    AppView(appState: AppState(option: .content))
}
