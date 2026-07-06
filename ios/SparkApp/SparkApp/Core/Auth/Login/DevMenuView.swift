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
    @Environment(SparkManager.self) private var sparkManager
    @Environment(UsersManager.self) private var userManager

    @State private var email: String
    @State private var password: String
    @State private var selectedEnvironment: APIEnvironment = .current
    @State private var userId: String = ""
    @State private var output: String = ""
    @State private var isRunning = false

    init(email: String, password: String) {
        _email = State(initialValue: email.isEmpty ? "example@gmail.com" : email)
        _password = State(initialValue: password.isEmpty ? "abcd1234!" : password)
    }

    var body: some View {
        NavigationStack {
            Form {
                environmentSection
                userActionsSection
                outputSection
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

    // MARK: - UsersManager methods

    private var userActionsSection: some View {
        Section("UsersManager") {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)

            TextField("Password", text: $password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Button("addUser") { runAddUser() }
                .disabled(isRunning || email.isEmpty || password.isEmpty)

            TextField("User ID", text: $userId)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Button("getUser") { runGetUser() }
                .disabled(isRunning || userId.isEmpty)
        }
    }

    private var outputSection: some View {
        Section("Output") {
            if isRunning {
                ProgressView()
            }
            Text(output.isEmpty ? "No output yet" : output)
                .font(.system(.footnote, design: .monospaced))
                .textSelection(.enabled)
                .foregroundStyle(output.isEmpty ? .secondary : .primary)
        }
    }

    // MARK: - Actions

    private func selectEnvironment(_ env: APIEnvironment) {
        APIEnvironment.current = env
        sparkManager.service = SparkServerService(environment: env)
        userManager.service = SparkUserService(environment: env)
        output = "Environment → \(env.rawValue)\n\(env.baseURL.absoluteString)"
    }

    private func runAddUser() {
        run {
            let user = try await userManager.addUser(email: email, password: password)
            userId = user.id
            return "addUser ✓\nid: \(user.id)\nemail: \(user.email)"
        }
    }

    private func runGetUser() {
        run {
            let user = try await userManager.getUser(userId: userId)
            return "getUser ✓\nid: \(user.id)\nemail: \(user.email)"
        }
    }

    private func run(_ operation: @escaping () async throws -> String) {
        isRunning = true
        output = ""
        Task {
            do {
                output = try await operation()
            } catch {
                output = "✗ \(error.localizedDescription)"
            }
            isRunning = false
        }
    }
}

#Preview {
    DevMenuView(email: "test@example.com", password: "secret")
        .previewEnvironment()
}
#endif
