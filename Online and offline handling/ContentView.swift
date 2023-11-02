//
//  ContentView.swift
//  Online and offline handling
//
//  Created by vignesh kumar c on 02/11/23.
//

import SwiftUI
import Network

struct NetworkStatusView: View {
    @State private var isOnline = true
    @State private var errorMessage = "No internet connection. Please check your network."
    private let networkMonitor = NWPathMonitor()

    var body: some View {
        ZStack {
            // Your main content goes here
            VStack {
                Text("Add what u have to do")
            }

            if !isOnline {
                // Display the error message at the bottom
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                }
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.7))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            networkMonitor.start(queue: DispatchQueue.global(qos: .background))
            networkMonitor.pathUpdateHandler = { path in
                isOnline = path.status == .satisfied
            }
        }
    }
//
//    private func checkInternetConnection() {
//        // You can perform any custom actions here when the "Refresh" button is tapped.
//    }
}

#Preview {
    NetworkStatusView()
}


class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
