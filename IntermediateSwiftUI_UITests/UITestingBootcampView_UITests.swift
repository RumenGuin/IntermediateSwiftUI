//
//  UITestingBootcampView_UITests.swift
//  IntermediateSwiftUI_UITests
//
//  Created by RUMEN GUIN on 26/01/22.
//

import XCTest

//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//Naming Structure: test_[struct]_[UI component]_[expected result]
//Testing Structure: Given, When, Then

class UITestingBootcampView_UITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        //app.launchArguments = ["-UITest_startSignedIn"]
      //  app.launchEnvironment = ["-UITest_startSignedIn" : "true"]
        app.launch()
        
    }

    override func tearDownWithError() throws {
    }

    func test_UITestingBootcampView_signUpButton_shouldNotSignIn() {
        
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        
        //When
        let navBar = app.navigationBars["Welcome"]
        //Then
        
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingBootcampView_signUpButton_shouldSignIn() {
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        //When
        
        let navBar = app.navigationBars["Welcome"]
        //Then
        
        XCTAssertTrue(navBar.exists)
        
    }

    
    func test_SignedInHomeView_showAlertButton_shouldDisplayAlert() {
        
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        //When
        tapAlertButton(shouldDismissAlert: false)
        
        
        //Then
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
    }
    
 
    
    func test_SignedInHomeView_showAlertButton_shouldDisplayAndDismissAlert() {
        
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        //When
      
        tapAlertButton(shouldDismissAlert: true)
        
        
        
        //Then
        let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5) // waitForExistence returns bool
        XCTAssertFalse(alertExists) //alert does not exist after we click the OK Button
    }
    
    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestination() {
        
        //Given
       signUpAndSignIn(shouldTypeOnKeyboard: true)
        //When
        tapNavigationLink(shouldDismissDestination: false)
      
        
        
        
        //Then
        let destinationText =  app.staticTexts["Destination"]
        XCTAssertTrue(destinationText.exists)
        
    }
    
    
    
    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        
        //Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        //When
       tapNavigationLink(shouldDismissDestination: true)
        
        //Then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertTrue(navBar.exists)
        
        
    }
    
    
//    func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//
//        //Given
//        //signUpAndSignIn(shouldTypeOnKeyboard: true)
//        //When
//       tapNavigationLink(shouldDismissDestination: true)
//
//        //Then
//        let navBar = app.navigationBars["Welcome"]
//        XCTAssertTrue(navBar.exists)
//
//
//    }
    
}

//MARK: Functions

extension UITestingBootcampView_UITests {
    
    func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
        let textField = app.textFields["SignUpTextfield"]
        textField.tap()
        
        if shouldTypeOnKeyboard {
            let keyA = app.keys["A"]
            keyA.tap()
            let key_a = app.keys["a"]
            key_a.tap()
            key_a.tap()
        }
        
        let returnButton = app.buttons["Return"]
        returnButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    
    func tapAlertButton(shouldDismissAlert:  Bool) {
        let showAlertButton = app.buttons["ShowAlertButton"]
        showAlertButton.tap()
        
        if shouldDismissAlert {
            let alert = app.alerts.firstMatch
            let alertOKButton = alert.buttons["OK"]
            let alertOKButtonExists = alertOKButton.waitForExistence(timeout: 5) // waitForExistence returns bool
            XCTAssertTrue(alertOKButtonExists)
            alertOKButton.tap()
        }
    }
    
    func tapNavigationLink(shouldDismissDestination: Bool) {
        let navLinkButton = app.buttons["NavigationLinkToDestination"]
         navLinkButton.tap()
        
        if shouldDismissDestination {
            let backButton = app.navigationBars.buttons["Welcome"]
            backButton.tap()
        }
    }
}
