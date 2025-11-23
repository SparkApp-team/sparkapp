//
//  SplashView.swift
//  SparkApp
//
//  Created by Dmitro Kryzhanovsky on 23.11.2025.
//
import SwiftUI

struct SplashView: View {
    @State var isStart: Bool = false
    @State var isActive: Bool = false
    @State var logoOffset: CGFloat = 0
    
    @State private var titleText = ""
    private let fullTitle = "SparkApp"
    
    var body: some View {
        if (isActive) {
            ContentView()
        } else {
            ZStack(alignment: .center) {
                Color(.logoBackground)
                
                Image(.testLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128, height: 128)
                    .offset(y: logoOffset)
                    .animation(.easeOut(duration: 0.8), value: logoOffset)
                
                Text(titleText)
                    .foregroundStyle(Color(.black))
                    .font(.title3)
                    .opacity(isStart ? 1 : 0)
                    .animation(.easeIn(duration: 0.4), value: isStart)
                    .offset(y: 30)
            }
            .ignoresSafeArea()
            .onAppear {
                startAnimation()
            }
        }
    }
    
    func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            logoOffset = -40
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isStart = true
                typeTitle()
            }
        }
    }
    
    func typeTitle() {
        titleText = ""
        
        for (index, letter) in fullTitle.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.08) {
                titleText.append(letter)
                if titleText == fullTitle {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
