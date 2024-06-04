//
//  PhoneToCarUpdateSoftwareActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarUpdateSoftwareActionView: View {
    var body: some View {
        VStack {
            Text("A new software version is available for your car. You can update your car from your phone.")
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                Image(systemName: "car.side")
                    .font(.system(size: 30))
                    .foregroundStyle(.tint)
                Image(systemName: "shippingbox.and.arrow.backward")
                    .font(.system(size: 30))
                    .foregroundStyle(.tint)
                Image(systemName: "iphone")
                    .font(.system(size: 30))
                    .foregroundStyle(.tint)
            }.padding()
            
            Button("Update car software") {
            }
        }
    }
}

#Preview {
    PhoneToCarUpdateSoftwareActionView()
}
