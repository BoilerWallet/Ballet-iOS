//
//  QRScannerViewController.swift
//  Ballet
//
//  Created by Ben Koska on 12/26/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import UIKit
import AVFoundation
import Material
import Crashlytics

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties

    @IBOutlet var videoPreview: UIView!
    @IBOutlet weak var backButton: IconButton!
    
    var dataString = String()
    var completion: ((_: String) -> Void)?

    private enum error: Error {
        case noCameraAvailable
        case videoInputInitFail
    }

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.image = Icon.close

        do {
            try scanQRCode()
        } catch {
            print("Failed to scan the QR/Barcode.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Functions

    private func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects:[Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                dataString = machineReadableCode.stringValue!
                if let completion = completion {
                    dismiss(animated: true, completion: {
                        completion(self.dataString)
                    })
                }
            }
        }
    }

    private func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()

        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No camera.")
            throw error.noCameraAvailable
        }

        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to init camera.")
            throw error.videoInputInitFail
        }

        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)

        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)

        avCaptureSession.startRunning()
    }

    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
