//
//  PhoneToCarLockUnlockActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarLockUnlockActionView: View {
    @ObservedObject private var viewModel = PhoneToCarLockUnlockActionViewModel()
    
    var body: some View {
        DoorLockStateView(
            isLoading: viewModel.isLoading,
            isLocked: viewModel.isLocked,
            unlockAction: {
                viewModel.unlockAction()
            },
            lockAction: {
                viewModel.lockAction()
            }
        )
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
    PhoneToCarLockUnlockActionView()
}
