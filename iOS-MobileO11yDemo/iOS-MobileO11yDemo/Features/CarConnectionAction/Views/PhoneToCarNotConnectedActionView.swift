//
//  PhoneToCarNotConnectedActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarNotConnectedActionView: View {
    @ObservedObject private var carConnectionService = CarConnectionService.instance
    
    var body: some View {
        VStack {
            Text("You are not yet connected to your car. If you are next to your car you can connect your phone to it and control it directly from your phone.")
                .multilineTextAlignment(.center)
                .padding()
            
            Divider().padding(.bottom, 10)
            
            if carConnectionService.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 50, height: 50)
                    .scaleEffect(1.5)
            } else {
                Image(systemName: "car")
                    .frame(width: 50, height: 50)
                    .font(.system(size: 40))
                    .foregroundStyle(.tint)
            }
            
            Button("Connect phone directly to car") {
                Task {
                    await carConnectionService.connectToCar()
                }
            }
            .disabled(carConnectionService.isLoading)
            .padding()
        }
    }
}

#Preview {
    PhoneToCarNotConnectedActionView()
}
