//
//  AppView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

struct AppView: View {
    @Environment(DependencyContainer.self) private var container
    @State var viewModel: AppViewModel

    var body: some View {
        AppViewBuilder(
            option: viewModel.stateOption,
            launch: {
                SplashView(viewModel: SplashViewModel(container: container))
            },
            auth: {
                LoginView()
            },
            content: {
                HabitsListView()
            }
        )
    }
}

#Preview("Launch") {
    let container = DevPreview.shared.container
    container.register(AppState(option: .launch))

    return AppView(viewModel: AppViewModel(container: container))
        .previewEnvironment()
}

#Preview("Auth") {
    let container = DevPreview.shared.container
    container.register(AppState(option: .auth))

    return AppView(viewModel: AppViewModel(container: container))
        .previewEnvironment()
}

#Preview("Content") {
    let container = DevPreview.shared.container
    container.register(AppState(option: .content))

    return AppView(viewModel: AppViewModel(container: container))
        .previewEnvironment()
}
