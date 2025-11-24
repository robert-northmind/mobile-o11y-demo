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
    @State var selectedErrorType: ErrorSimulationType = .random
    
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
                        try await remoteActionService.unlockDoors(errorType: selectedErrorType)
                        return CarDoorStatus(status: "unlocked")
                    }
                },
                lockAction: {
                    performRemoteAction {
                        try await remoteActionService.lockDoors(errorType: selectedErrorType)
                        return CarDoorStatus(status: "locked")
                    }
                }
            ).padding()
            
            // Error Simulation Picker
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "ladybug")
                        .foregroundColor(.orange)
                    Text("Error Simulation")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                Picker("Error Type", selection: $selectedErrorType) {
                    ForEach(ErrorSimulationType.allCases) { errorType in
                        Text(errorType.displayName).tag(errorType)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
            
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
        let updatedDoorStatus = await remoteActionService.getDoorStatus(errorType: selectedErrorType)
        
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
