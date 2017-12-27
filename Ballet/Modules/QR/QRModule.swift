//
//  QRModule.swift
//  Ballet
//
//  Created by Ben Koska on 12/26/17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Crashlytics

class QRModule {

    var completion: (_: String) -> Void

    init(completion: @escaping (_: String) -> Void) {
        self.completion = completion
    }

    func present(on: UIViewController) {
        guard checkCamera() else {
            // TODO: Add Popup Saying "No Cameras for larrys"
            return
        }

        let cont = UIStoryboard(name: "QRScanner", bundle: nil).instantiateInitialViewController() as? QRScannerViewController
        cont?.completion = completion
        if let cont = cont {
            on.present(cont, animated: true, completion: nil)
        } else {
            print("could not unwrap controler")
            Crashlytics.sharedInstance().logEvent("QRModule: Could Not Unwrap QR Scanner")
        }
    }

    private func checkCamera() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        }

        return false
    }
}
