//
//  DevMenuToolbar.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 07.07.2026.
//

import SwiftUI

/// Adds a leading toolbar button that presents the `DevMenuView`.
/// Compiled out entirely in release builds.
private struct DevMenuToolbar: ViewModifier {
    #if DEBUG
    @Environment(DependencyContainer.self) private var container
    @State private var showDevMenu = false
    #endif

    let email: Binding<String>?
    let password: Binding<String>?
    let confirmPassword: Binding<String>?

    func body(content: Content) -> some View {
        #if DEBUG
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showDevMenu = true
                    } label: {
                        Label("Dev Menu", systemImage: "hammer.fill")
                    }
                }
            }
            .sheet(isPresented: $showDevMenu) {
                DevMenuView(email: email, password: password, confirmPassword: confirmPassword)
            }
        #else
        content
        #endif
    }
}

extension View {
    /// Presents a leading "Dev Menu" toolbar button in DEBUG builds only.
    /// The view must be inside a `NavigationStack` for the toolbar to appear.
    ///
    /// Pass field bindings to enable the "Test Accounts" autofill section
    /// (e.g. Login passes email + password; Register also passes confirmPassword).
    func devMenuToolbar(
        email: Binding<String>? = nil,
        password: Binding<String>? = nil,
        confirmPassword: Binding<String>? = nil
    ) -> some View {
        modifier(DevMenuToolbar(email: email, password: password, confirmPassword: confirmPassword))
    }
}
