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
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
            } else {
                Image(systemName: doorStatus?.iconName ?? "car.side.and.exclamationmark")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            Text("Car doors state is: \(doorStatus?.status ?? "unknown")")
                .padding(.bottom, 20)
                .padding(.top, 20)
            HStack {
                Button("Unlock") {
                    performRemoteAction {
                        let remoteActionService = InjectedValues[\.remoteActionService]
                        await remoteActionService.unlockDoors()
                    }
                }
                .disabled(isLoading)
                .padding(.trailing, 20)
                Button("Lock") {
                    performRemoteAction {
                        let remoteActionService = InjectedValues[\.remoteActionService]
                        await remoteActionService.lockDoors()
                    }
                }.disabled(isLoading)
            }
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
            let remoteActionService = InjectedValues[\.remoteActionService]
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
