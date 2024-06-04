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
    @State private var showAlert = false
    
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
                        let remoteActionService = InjectedValues[\.remoteActionService]
                        await remoteActionService.unlockDoors()
                    }
                },
                lockAction: {
                    performRemoteAction {
                        let remoteActionService = InjectedValues[\.remoteActionService]
                        await remoteActionService.lockDoors()
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
                message: Text("Could not fetch door status"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func performRemoteAction(action: @escaping () async -> Void) {
        isLoading = true
        Task {
            await action()
            await updateDoorStatus()
        }
    }
    
    private func updateDoorStatus() async {
        let remoteActionService = InjectedValues[\.remoteActionService]
        let updatedDoorStatus = await remoteActionService.getDoorStatus()
        
        DispatchQueue.main.async {
            if let updatedDoorStatus = updatedDoorStatus {
                doorStatus = updatedDoorStatus
            } else {
                showAlert = true
            }
            isLoading = false
        }
    }
}

#Preview {
    RemoteActionView()
}
