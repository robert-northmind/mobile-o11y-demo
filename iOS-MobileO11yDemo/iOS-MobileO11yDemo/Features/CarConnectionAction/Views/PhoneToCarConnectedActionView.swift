//
//  PhoneToCarConnectedActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarConnectedActionView: View {
    @ObservedObject private var carConnectionService = CarConnectionService.instance
    
    var body: some View {
        VStack {
            Text("Nice! You are connected to your car and can directly control it via your phone.")
                .multilineTextAlignment(.center)
                .padding()
            
            Divider().padding(.bottom, 20)
            
            if carConnectionService.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 50, height: 50)
                    .scaleEffect(1.5)
            } else {
                Image(systemName: "car.front.waves.down")
                    .frame(width: 50, height: 50)
                    .font(.system(size: 50))
                    .foregroundStyle(.tint)
            }
            
            Button("Disconnect phone from car") {
                Task {
                    await carConnectionService.disconnectFromCar()
                }
            }
            .disabled(carConnectionService.isLoading)
            .padding()
            
            Divider()
            
            Group {
                PhoneToCarLockUnlockActionView()
                    .padding()
                
                Divider()
                
                PhoneToCarUpdateSoftwareActionView()
                    .padding()
            }.disabled(carConnectionService.isLoading)
        }
    }
}

#Preview {
    PhoneToCarConnectedActionView()
}
