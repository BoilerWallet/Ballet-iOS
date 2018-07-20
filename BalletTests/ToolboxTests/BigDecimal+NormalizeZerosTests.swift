//
//  BigDecimal+NormalizeZerosTests.swift
//  BalletTests
//
//  Created by Koray Koska on 20.07.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import XCTest
import BigInt
@testable import Ballet

class BigDecimalNormalizeZerosTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNormalization() {
        let decimal1 = BigDecimal(sign: .plus, exponent: 5, significand: 12340000)
        let decimal1Normalized = decimal1.normalizeZeros()
        XCTAssertEqual(decimal1, decimal1Normalized)
        XCTAssertEqual(decimal1Normalized.sign, .plus)
        XCTAssertEqual(decimal1Normalized.exponent, 9)
        XCTAssertEqual(decimal1Normalized.significand, 1234)

        let decimal2 = BigDecimal(sign: .minus, exponent: -5, significand: 12340000)
        let decimal2Normalized = decimal2.normalizeZeros()
        XCTAssertEqual(decimal2, decimal2Normalized)
        XCTAssertEqual(decimal2Normalized.sign, .minus)
        XCTAssertEqual(decimal2Normalized.exponent, -1)
        XCTAssertEqual(decimal2Normalized.significand, 1234)

        let decimal3 = BigDecimal(sign: .minus, exponent: 7, significand: 5543667)
        let decimal3Normalized = decimal3.normalizeZeros()
        XCTAssertEqual(decimal3, decimal3Normalized)
        XCTAssertEqual(decimal3Normalized.sign, .minus)
        XCTAssertEqual(decimal3Normalized.exponent, 7)
        XCTAssertEqual(decimal3Normalized.significand, 5543667)

        let decimal4 = BigDecimal(sign: .plus, exponent: -9, significand: 123555)
        let decimal4Normalized = decimal4.normalizeZeros()
        XCTAssertEqual(decimal4, decimal4Normalized)
        XCTAssertEqual(decimal4Normalized.sign, .plus)
        XCTAssertEqual(decimal4Normalized.exponent, -9)
        XCTAssertEqual(decimal4Normalized.significand, 123555)

        let decimal5 = BigDecimal(sign: .plus, exponent: 0, significand: 0)
        let decimal5Normalized = decimal5.normalizeZeros()
        XCTAssertEqual(decimal5, decimal5Normalized)
        XCTAssertEqual(decimal5Normalized.sign, .plus)
        XCTAssertEqual(decimal5Normalized.exponent, 0)
        XCTAssertEqual(decimal5Normalized.significand, 0)

        let decimal6 = BigDecimal(sign: .plus, exponent: 9, significand: 0)
        let decimal6Normalized = decimal6.normalizeZeros()
        XCTAssertEqual(decimal6, decimal6Normalized)
        XCTAssertEqual(decimal6Normalized.sign, .plus)
        XCTAssertEqual(decimal6Normalized.exponent, 9)
        XCTAssertEqual(decimal6Normalized.significand, 0)
    }
}
