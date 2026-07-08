//
//  DevMenuView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 06.07.2026.
//

#if DEBUG
import SwiftUI

struct DevMenuView: View {
    @Environment(\.dismiss) private var dismiss
    private var healthManager: HealthManager
    private var userManager: UserManager
    private var appState: AppState

    var email: Binding<String>?
    var password: Binding<String>?
    var confirmPassword: Binding<String>?

    @State private var selectedEnvironment: APIEnvironment = .current

    private var canAutofill: Bool {
        email != nil || password != nil
    }

    init(
        container: DependencyContainer,
        email: Binding<String>? = nil,
        password: Binding<String>? = nil,
        confirmPassword: Binding<String>? = nil
    ) {
        self.healthManager = container.resolve(HealthManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.appState = container.resolve(AppState.self)!
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }

    var body: some View {
        NavigationStack {
            Form {
                environmentSection
                if canAutofill {
                    testAccountsSection
                }
                sessionSection
            }
            .navigationTitle("Dev Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // MARK: - Base link

    private var environmentSection: some View {
        Section("API Environment") {
            Picker("Base URL", selection: $selectedEnvironment) {
                ForEach(APIEnvironment.allCases, id: \.self) { env in
                    Text(env.rawValue).tag(env)
                }
            }
            .onChange(of: selectedEnvironment) { _, env in
                selectEnvironment(env)
            }

            Text(selectedEnvironment.baseURL.absoluteString)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Test accounts

    private var testAccountsSection: some View {
        Section("Test Accounts") {
            ForEach(TestAccount.presets) { account in
                Button {
                    autofill(with: account)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(account.label)
                            .foregroundStyle(.primary)
                        Text("\(account.email) · \(account.password)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Session

    private var sessionSection: some View {
        Section("Session") {
            if let user = userManager.currentUser {
                Text("Signed in: \(user.email)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if let userId = UserDefaults.currentUserId {
                Text("User ID: \(userId)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }

            Button(role: .destructive) {
                logout()
            } label: {
                Text("Log Out")
            }
            .disabled(userManager.currentUser == nil)
        }
    }

    // MARK: - Actions

    private func selectEnvironment(_ env: APIEnvironment) {
        APIEnvironment.current = env
        healthManager.service = SparkHealthService()
    }

    private func autofill(with account: TestAccount) {
        email?.wrappedValue = account.email
        password?.wrappedValue = account.password
        confirmPassword?.wrappedValue = account.password
        dismiss()
    }

    private func logout() {
        dismiss()

        // Let the sheet finish its dismiss animation before tearing down the
        // session, so the menu visibly closes first and then we log out.
        Task {
            try? await Task.sleep(for: .seconds(0.35))
            userManager.logout()
            appState.updateState(option: .auth)
        }
    }
}

struct TestAccount: Identifiable {
    let id = UUID()
    let label: String
    let email: String
    let password: String

    static let presets: [TestAccount] = [
        TestAccount(label: "User 1", email: "example@gmail.com", password: "pass1234!"),
        TestAccount(label: "User 2", email: "user2@gmail.com", password: "pass1234!"),
    ]
}

#Preview {
    DevMenuView(container: DevPreview.shared.container)
        .previewEnvironment()
}
#endif
