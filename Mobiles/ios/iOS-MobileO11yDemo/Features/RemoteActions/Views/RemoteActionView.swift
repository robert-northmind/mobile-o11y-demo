//
//  RemoteActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct RemoteActionView: View {
    @State var doorStatus: CarDoorStatus?
    @State var isLoading = false
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    
    private let remoteActionService = InjectedValues[\.remoteActionService]
    
    var body: some View {
        VStack {
            Text("Here you can control your car from anywhere in the world!")
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            DoorLockStateView(
                isLoading: isLoading,
                isLocked: doorStatus?.isLocked,
                unlockAction: {
                    performRemoteAction {
                        try await remoteActionService.unlockDoors()
                        return CarDoorStatus(status: "unlocked")
                    }
                },
                lockAction: {
                    performRemoteAction {
                        try await remoteActionService.lockDoors()
                        return CarDoorStatus(status: "locked")
                    }
                }
            ).padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            isLoading = true
            Task {
                await updateDoorStatus()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func performRemoteAction(action: @escaping () async throws -> CarDoorStatus) {
        isLoading = true
        Task {
            do {
                let updatedDoorStatus = try await action()
                DispatchQueue.main.async {
                    doorStatus = updatedDoorStatus
                }
            } catch {
                alertMessage = "Could not change door status. Error: \(error)"
                showAlert = true
            }
            isLoading = false
        }
    }
    
    private func updateDoorStatus() async {
        isLoading = true
        let updatedDoorStatus = await remoteActionService.getDoorStatus()
        
        DispatchQueue.main.async {
            if let updatedDoorStatus = updatedDoorStatus {
                doorStatus = updatedDoorStatus
            } else {
                alertMessage = "Could not fetch door status"
                showAlert = true
            }
            isLoading = false
        }
    }
}

#Preview {
    RemoteActionView()
}
