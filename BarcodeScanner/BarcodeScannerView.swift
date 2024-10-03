//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Isuru Ariyarathna on 2024-10-03.
//

import SwiftUI

struct BarcodeScannerView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer()
                    .frame(height: 60)
                
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text("Not Scanned")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
