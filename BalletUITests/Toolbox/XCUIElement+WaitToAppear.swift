//
//  XCUIElement+WaitToAppear.swift
//  BalletUITests
//
//  Created by Koray Koska on 19.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import XCTest

extension XCUIElement {

    func waitToAppear(on testCase: XCTestCase, timeout: TimeInterval = 5, file: String = #file, line: Int = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        testCase.expectation(for: existsPredicate, evaluatedWith: self, handler: nil)

        testCase.waitForExpectations(timeout: timeout) { error in
            if error != nil {
                let message = "Failed to find \(self) after \(timeout) seconds."
                testCase.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
}
