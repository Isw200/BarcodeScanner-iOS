//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Isuru Ariyarathna on 2024-10-03.
//

import SwiftUI

struct BarcodeScannerView: View {
    @State private var scannedCode = ""
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScannerView(scannedCode: $scannedCode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 60)
                
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(scannedCode.isEmpty ? "Not Yet Scanned" : "\(scannedCode)")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(scannedCode.isEmpty ? .red : .green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
