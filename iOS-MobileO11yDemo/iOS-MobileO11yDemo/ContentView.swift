//
//  ContentView.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Group {
                PhoneToCarActionView()
                    .tabItem { Label("Phone To Car Actions", systemImage: "car.front.waves.down").padding() }
                
                RemoteActionView()
                    .tabItem { Label("Remote Actions", systemImage: "network").padding() }
            }
            .toolbarBackground(.gray.opacity(0.1), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
