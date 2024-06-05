//
//  PhoneToCarUpdateSoftwareActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarUpdateSoftwareActionView: View {
    @ObservedObject private var viewModel = PhoneToCarUpdateSoftwareActionViewModel()
    
    var body: some View {
        VStack {
            Text("A new software version is available for your car. You can update your car from your phone.")
                .multilineTextAlignment(.center)
                .padding(5)
            
            Text("Current version: \(viewModel.currentSoftwareVersion)")
            Text("New version: \(viewModel.nextSoftwareVersion)")
            
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
            }.padding(10)
            
            Button("Update car software") {
                viewModel.updateSoftware()
            }.disabled(viewModel.isUpdating)
            
            if viewModel.isUpdating {
                ProgressView(value: viewModel.progress, total: 100)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    PhoneToCarUpdateSoftwareActionView()
}
