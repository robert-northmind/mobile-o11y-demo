//
//  PhoneToCarActionView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import SwiftUI

struct PhoneToCarActionView: View {
    @ObservedObject private var viewModel = PhoneToCarActionViewModel()

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isConnected {
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
