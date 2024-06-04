//
//  PhoneToCarConnectedActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarConnectedActionView: View {
    var body: some View {
        VStack {
            Text("Nice! You are connected to your car and can directly control it via your phone.")
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            Image(systemName: "car.front.waves.down")
                .font(.system(size: 50))
                .foregroundStyle(.tint)
                .padding()
            
            Button("Disconnect phone from car") {
            }.padding()
            
            Divider()
            
            PhoneToCarLockUnlockActionView()
                .padding()
            
            Divider()
            
            PhoneToCarUpdateSoftwareActionView()
                .padding()
        }
    }
}

#Preview {
    PhoneToCarConnectedActionView()
}
