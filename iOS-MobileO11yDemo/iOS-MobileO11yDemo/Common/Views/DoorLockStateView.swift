//
//  DoorLockStateView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct DoorLockStateView: View {
    let isLoading: Bool
    let isLocked: Bool?
    let unlockAction: () -> Void
    let lockAction: () -> Void
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
            } else {
                Image(systemName: getDoorSateIcon())
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            Text("Car doors state is: \(getDoorSateText())")
                .padding(.bottom, 20)
                .padding(.top, 20)
            HStack {
                Button("Unlock") {
                    unlockAction()
                }
                .disabled(isLoading)
                .padding(.trailing, 20)
                Button("Lock") {
                    lockAction()
                }.disabled(isLoading)
            }
        }
    }
    
    private func getDoorSateText() -> String {
        guard let isLocked = isLocked else { return "unknown"}
        return isLocked ? "locked" : "unlocked"
    }
    
    private func getDoorSateIcon() -> String {
        guard let isLocked = isLocked else {
            return "car.side.and.exclamationmark"
        }
        return isLocked ? "car.side.lock" : "car.side.lock.open"
    }
}

#Preview {
    DoorLockStateView(
        isLoading: false,
        isLocked: nil,
        unlockAction: {},
        lockAction: {}
    )
}
