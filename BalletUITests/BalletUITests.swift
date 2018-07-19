//
//  BalletUITests.swift
//  BalletUITests
//
//  Created by Koray Koska on 17.12.17.
//  Copyright © 2017 Boilertalk. All rights reserved.
//

import XCTest

class BalletUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        XCUIDevice.shared.orientation = .portrait

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["--Reset"]
        app.launch()

        // Always login before testing
        login()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// General login
    func login() {
        let app = XCUIApplication()

        let setPassword: (_ textField: XCUIElement) -> Void = { textField in
            textField.typeText("123shithole")
        }

        // Select Password TextField
        let passwordTextField = app.secureTextFields["password_text"]
        passwordTextField.tap()
        setPassword(passwordTextField)

        // Select Confirm Password TextField
        let confirmTextField = app.secureTextFields["confirm_password_text"]
        confirmTextField.tap()
        setPassword(confirmTextField)

        // Close Keyboard
        confirmTextField.typeText("\n")

        app.buttons["Login"].tap()

        // Wait until login is done
        let icAddButton = app.buttons["ic_add"]
        icAddButton.waitToAppear(on: self)
        XCTAssert(icAddButton.exists)
    }

    /// Tests creating an account
    func testCreateAccount() {
        let app = XCUIApplication()
        app.buttons["ic_add"].tap()
        
        let selectYourFavouriteNewAccountElementsQuery = app.scrollViews.otherElements.containing(.staticText, identifier:"Select your favourite new Account!")

        // Select Account
        selectYourFavouriteNewAccountElementsQuery.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element(boundBy: 2).children(matching: .other)
            .element(boundBy: 0).children(matching: .other)
            .element.children(matching: .other).element
            .tap()

        // Select TextField
        let nameTextField = app.textFields["account_name"]
        nameTextField.tap()
        nameTextField.typeText("First Account")

        // Close Keyboard
        nameTextField.typeText("\n")

        app.buttons["Create"].tap()

        // Wait until account is created
        let accountCell = app.collectionViews.cells.firstMatch
        accountCell.waitToAppear(on: self, timeout: 10)
        XCTAssert(accountCell.exists)
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
