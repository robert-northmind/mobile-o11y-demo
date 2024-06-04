//
//  PhoneToCarNotConnectedActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarNotConnectedActionView: View {
    var body: some View {
        VStack {
            Text("You are not yet connected to your car. You can connect your phone to the car and then control it directly from your phone.")
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            Image(systemName: "car")
                .font(.system(size: 40))
                .foregroundStyle(.tint)
                .padding()
            
            Button("Connect phone directly to car") {
            }.padding()
        }
    }
}

#Preview {
    PhoneToCarNotConnectedActionView()
}
