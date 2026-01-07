//
//  Color+uiColor.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 01.12.2025.
//

import SwiftUI

extension Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    static func random() -> Color {
        Color(
            red: .random(in: 0.3...0.8),
            green: .random(in: 0.3...0.8),
            blue: .random(in: 0.3...0.8)
        )
    }
}
