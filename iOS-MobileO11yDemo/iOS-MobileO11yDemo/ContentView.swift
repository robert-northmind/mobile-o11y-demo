//
//  ContentView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import SwiftUI

struct ContentView: View {
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
                    isLoading = true
                    Task {
                        let remoteActionService = InjectedValues[\.remoteActionService]
                        await remoteActionService.unlockDoors()
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
                .disabled(isLoading)
                .padding(.trailing, 20)
                Button("Lock") {
                    isLoading = true
                    Task {
                        let remoteActionService = InjectedValues[\.remoteActionService]
                        await remoteActionService.lockDoors()
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
                }.disabled(isLoading)
            }
        }
        .padding()
        .onAppear {
            isLoading = true
            Task {
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text("Could not fetch door status"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ContentView()
}
