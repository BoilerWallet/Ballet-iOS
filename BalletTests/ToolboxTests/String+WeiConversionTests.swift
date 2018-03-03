//
//  String+WeiConversionTests.swift
//  BalletTests
//
//  Created by Koray Koska on 03.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import XCTest
@testable import Ballet

class StringWeiConversionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWeiToEth() {
        // Random Shit
        XCTAssertEqual("1121212132321122341".weiToEth(), 1.121212132321122341)

        // Edge cases
        XCTAssertEqual("1".weiToEth(), 0.000000000000000001)
        XCTAssertEqual("0".weiToEth(), 0)
        XCTAssertEqual("100000000000000000".weiToEth(), 0.1)
        XCTAssertEqual("1000000000000000000".weiToEth(), 1)
        XCTAssertEqual("1000000000000000001".weiToEth(), 1.000000000000000001)
    }
}
