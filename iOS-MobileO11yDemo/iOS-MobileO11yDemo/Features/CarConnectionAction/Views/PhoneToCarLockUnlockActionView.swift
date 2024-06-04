//
//  PhoneToCarLockUnlockActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarLockUnlockActionView: View {
    var body: some View {
        DoorLockStateView(
            isLoading: false,
            isLocked: true,
            unlockAction: {
            },
            lockAction: {
            }
        )
    }
}

#Preview {
    PhoneToCarLockUnlockActionView()
}
