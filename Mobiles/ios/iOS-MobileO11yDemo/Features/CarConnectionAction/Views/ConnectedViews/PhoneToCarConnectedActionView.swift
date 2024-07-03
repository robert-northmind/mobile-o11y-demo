//
//  PhoneToCarConnectedActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarConnectedActionView: View {
    @ObservedObject private var viewModel = PhoneToCarConnectedActionViewModel()
    
    var body: some View {
        VStack {
            Text("Connected to: \(viewModel.vehicleInfo)")
                .multilineTextAlignment(.center)
                .padding()
            
            if viewModel.isLoading {
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
                viewModel.disconnectFromCar()
            }
            .padding()
            
            Divider()
            
            PhoneToCarLockUnlockActionView()
                .padding()
            
            Divider()
            
            PhoneToCarUpdateSoftwareActionView()
                .padding()
            
        }.disabled(viewModel.isLoading)
    }
}

#Preview {
    PhoneToCarConnectedActionView()
}
