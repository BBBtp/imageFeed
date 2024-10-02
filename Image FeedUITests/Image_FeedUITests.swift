//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Богдан Топорин on 01.10.2024.
//

import XCTest

enum DataTests{
    static let login = "ur_email"
    static let password = "ur_pass"
    static let lastName = "ur_ln"
    static let profileLogin = "@ur_log"
    static let alertName = "ur_an"
    static let autnButtonName = "ur_bn"
    static let singleImageBackButtonName = "ur_bn"
    static let logoutButtonName = "ur_bn"
}
class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launchArguments = ["-UITesting"]
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        
        app.buttons[DataTests.autnButtonName].tap()

        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
       
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText(DataTests.login)
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText(DataTests.password)
        webView.swipeUp()

        webView.buttons["Login"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }

    func testFeed() throws {
        
        sleep(4)
        let cell = app.tables.descendants(matching: .cell).element(boundBy: 0)
        let likeButton = cell.buttons.firstMatch
        
        app.swipeUp()
        sleep(1)
        app.swipeDown()
        likeButton.tap()
        sleep(1)
        likeButton.tap()
        sleep(2)
        
        cell.tap()
        
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1) // zoom in
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1) // zoom out

        let navBackButtonWhiteButton = app.buttons[DataTests.singleImageBackButtonName]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(1)
        
        XCTAssertTrue(app.staticTexts[DataTests.lastName].exists)
        XCTAssertTrue(app.staticTexts[DataTests.profileLogin].exists)

        app.buttons[DataTests.logoutButtonName].tap()

        app.alerts[DataTests.alertName].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        XCTAssertTrue(app.buttons[DataTests.autnButtonName].exists)
    }

} 
