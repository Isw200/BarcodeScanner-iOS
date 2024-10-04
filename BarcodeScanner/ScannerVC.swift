//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Isuru Ariyarathna on 2024-10-04.
//

import UIKit
import AVFoundation

enum CameraError: String {
    case invalidDeviceInput = "Invalid device input"
    case invalidScanVlaue = "Invalid scan value"
}

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil , bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard previewLayer != nil else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
    }
    
    private func setupCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            try videoInput = AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(videoInput)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue:DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
}


extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScanVlaue)
            return
        }
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScanVlaue)
            return
        }
        guard let stringValue = readableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScanVlaue)
            return
        }
        
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: stringValue)
    }
}
