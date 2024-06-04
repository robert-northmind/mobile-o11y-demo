//
//  PhoneToCarActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarActionView: View {
    @State var isConnected = true

    var body: some View {
        ScrollView {
            VStack {
                if isConnected {
                    PhoneToCarConnectedActionView()
                } else {
                    PhoneToCarNotConnectedActionView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    PhoneToCarActionView()
}
