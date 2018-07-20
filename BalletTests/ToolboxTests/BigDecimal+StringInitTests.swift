//
//  BigDecimal+StringInitTests.swift
//  BalletTests
//
//  Created by Koray Koska on 20.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import XCTest
import BigInt
@testable import Ballet

class BigDecimalStringInitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBigDecimalAmericanStyleStringInit() {
        // Normal decimals
        XCTAssertEqual(BigDecimal(string: "1234.444567"), BigDecimal(sign: .plus, exponent: -6, significand: 1234444567))
        XCTAssertEqual(BigDecimal(string: "-4325.77632"), BigDecimal(sign: .minus, exponent: -5, significand: 432577632))
        XCTAssertEqual(BigDecimal(string: "-2549"), BigDecimal(sign: .minus, exponent: 0, significand: 2549))
        XCTAssertEqual(BigDecimal(string: "+12121267"), BigDecimal(sign: .plus, exponent: 0, significand: 12121267))
        XCTAssertEqual(BigDecimal(string: "+0.1234"), BigDecimal(sign: .plus, exponent: -4, significand: 1234))
        XCTAssertEqual(BigDecimal(string: "-0.4356"), BigDecimal(sign: .minus, exponent: -4, significand: 4356))

        // Edge cases
        XCTAssertEqual(BigDecimal(string: "0"), BigDecimal(sign: .plus, exponent: 0, significand: 0))
        XCTAssertEqual(BigDecimal(string: "0.0"), BigDecimal(sign: .plus, exponent: 0, significand: 0))
        XCTAssertEqual(BigDecimal(string: ""), BigDecimal(sign: .plus, exponent: 0, significand: 0))
        XCTAssertEqual(BigDecimal(string: ".77654"), BigDecimal(sign: .plus, exponent: -5, significand: 77654))
        XCTAssertEqual(BigDecimal(string: "-.888765"), BigDecimal(sign: .minus, exponent: -6, significand: 888765))
        XCTAssertEqual(BigDecimal(string: "+.5554363"), BigDecimal(sign: .plus, exponent: -7, significand: 5554363))
        XCTAssertEqual(BigDecimal(string: "12334454."), BigDecimal(sign: .plus, exponent: 0, significand: 12334454))
        XCTAssertEqual(BigDecimal(string: "-4445653."), BigDecimal(sign: .minus, exponent: 0, significand: 4445653))
    }
}
