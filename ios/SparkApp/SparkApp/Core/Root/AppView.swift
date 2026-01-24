//
//  AppView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

struct AppView: View {
    @Environment(AppState.self) private var appState
    
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
    }
}



#Preview("Launch") {
    AppView()
        .environment(AppState(option: .launch))
        .previewEnvironment()
}

#Preview("Auth") {
    AppView()
        .environment(AppState(option: .auth))
        .previewEnvironment()
}

#Preview("Content") {
    AppView()
        .environment(AppState(option: .content))
        .previewEnvironment()
}
