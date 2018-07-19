//
//  main.swift
//  Ballet
//
//  Created by Koray Koska on 19.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

private enum AppReset {

    /// Only call this for UI tests. It resets all data in the app.
    static func resetAppData() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }

        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}


_ = autoreleasepool {

    if ProcessInfo().arguments.contains("--Reset") {
        AppReset.resetAppData()
    }

    UIApplicationMain(
        CommandLine.argc,
        UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
        nil,
        NSStringFromClass(AppDelegate.self)
    )
}
