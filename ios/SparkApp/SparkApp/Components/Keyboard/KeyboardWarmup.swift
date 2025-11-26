//
//  KeyboardWarmup.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//

import SwiftUI

class KeyboardWarmup {
    static func warmupInBackground() {
        DispatchQueue.global(qos: .background).async {
            // Preload keyboard resources
            let _ = UITextInputMode.activeInputModes
            // Preload text input system
            let _ = UITextChecker()

            DispatchQueue.main.async {
                // Create offscreen textfield
                let textField = UITextField()
                textField.frame = CGRect(x: -10000, y: -10000, width: 1, height: 1)
                textField.isHidden = true
                textField.alpha = 0.0

                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.addSubview(textField)

                    // Brief activation
                    textField.becomeFirstResponder()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        textField.resignFirstResponder()
                        textField.removeFromSuperview()
                        print("✅ Keyboard warmed up")
                    }
                }
            }
        }
    }
}
