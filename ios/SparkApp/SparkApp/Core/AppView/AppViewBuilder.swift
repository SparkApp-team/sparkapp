//
//  AppViewBuilder.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.01.2026.
//

import SwiftUI

struct AppViewBuilder<AuthView: View, ContentView: View, LaunchView: View>: View {
    
    var option: AppStateOption = .default
    
    @ViewBuilder var launch: LaunchView
    @ViewBuilder var auth: AuthView
    @ViewBuilder var content: ContentView
    
    var body: some View {
        ZStack {
            switch option {
            case .launch:
                launch
                    .transition(.move(edge: .leading))
            case .auth:
                auth
                    .transition(.move(edge: .trailing))
            case .content:
                content
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: option)
        .ignoresSafeArea()
    }
}
