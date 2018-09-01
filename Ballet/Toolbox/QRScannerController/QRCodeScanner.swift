//
//  QRCodeScanner.swift
//  Ballet
//
//  Created by Koray Koska on 01.09.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    let view: UIView

    var completion: ((_ str: String) -> Void)?

    private(set) var booted: Bool = false
    private(set) var started: Bool = false

    private var captureSession: AVCaptureSession
    private var previewLayer: AVCaptureVideoPreviewLayer!

    init(on view: UIView) {
        self.view = view

        self.captureSession = AVCaptureSession()
    }

    func boot() -> Bool {
        if booted {
            return true
        }

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return false
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return false
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return false
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return false
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // captureSession.startRunning()

        booted = true

        return true
    }

    func start() -> Bool {
        if started {
            return true
        }

        if !booted {
            if !boot() {
                return false
            }
        }

        started = true
        captureSession.startRunning()

        return true
    }

    func stop() {
        if !booted || !started {
            return
        }

        started = false
        captureSession.stopRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if !started {
            print("wtf!")
            return
        }

        stop()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            completion?(stringValue)
        }
    }
}
