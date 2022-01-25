//
//  UnitTestingViewModel_Tests.swift
//  IntermediateSwiftUI_Tests
//
//  Created by RUMEN GUIN on 25/01/22.
//

import XCTest
import Combine
@testable import IntermediateSwiftUI

//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//Naming Structure: test_[struct or class]_[variable or function]_[expected result]
//Testing Structure: Given, When, Then

class UnitTestingViewModel_Tests: XCTestCase {
    
    var viewModel: UnitTestingBootcampViewModel?
    var cancellables = Set<AnyCancellable>()
    
    //setUp will call before all this test
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestingBootcampViewModel(isPremium: Bool.random())
    }
    
    //teardown will call after all this test
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func test_UnitTestingBootcampViewModel_isPremium_shouldBeTrue() {
        //Given
        let userIsPremium: Bool = true
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        
        //Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeFalse() {
        //Given
        let userIsPremium: Bool = false
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        
        //Then
        XCTAssertFalse(vm.isPremium)
    }
    
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue() {
        //Given
        let userIsPremium: Bool = Bool.random()  //random bool
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        
        //Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue_stress() {
         
        for _ in 0..<10 {
            
            //Given
            let userIsPremium: Bool = Bool.random()
            
            //When
            let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
            
            //Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldBeEmpty() {
        //Given
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldAddItems() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString) //random string (UUID() always produces a string with 36 characters)
        }
        
        //Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0) //not equal to 0
        XCTAssertGreaterThan(vm.dataArray.count, 0)
       // XCTAssertGreaterThanOrEqual
        // XCTAssertLessThan
        // XCTAssertLessThanOrEqual
        
    }
    
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlankString() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        vm.addItem(item: "")
        
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty) //dataArray is empty as item is not added
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlankString2() {
        //Given
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        
        //When
        vm.addItem(item: "")
        
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty) //dataArray is empty as item is not added
    }
    
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldStartAsNil() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        vm.addItem(item: "")
        
        //Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        
        //select valid item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        //select invalid item
        vm.selectItem(item: UUID().uuidString)
        
        //Then
        XCTAssertNil(vm.selectedItem)
    }
    
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        //Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
        
    }
    
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected_stress() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty) //randomItem is not empty
        vm.selectItem(item: randomItem)
        
        //Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
        
    }
    
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_itemNotFound() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        //Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw item Not found error!") { error in
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.itemNotFound)
        }
    }
    
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_noData() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        //Then
        
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.noData)
        }
    }
    
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldSaveItem() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)  //randomItem is not empty
        //Then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem)) //randomItem cannot throw error
        
        //do catch == XCTAssertNoThrow (both doing the same thing here)
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    
    func test_UnitTestingBootcampViewModel_downloadWithEscaping_shouldReturnItems() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let expectation = XCTestExpectation(description: "Should return items after 3 sec")
        vm.$dataArray
            .dropFirst() //drop the first publish, dataArray at very init is going to publish a blank array as soon as we set values
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithEscaping()
       
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0) //greater than 0
       
    }
    
    
    func test_UnitTestingBootcampViewModel_downloadWithCombine_shouldReturnItems() {
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        
        //When
        let expectation = XCTestExpectation(description: "Should return items after a sec")
        vm.$dataArray
            .dropFirst() //drop the first publish, dataArray at very init is going to publish a blank array as soon as we set values
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
       
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0) //greater than 0
       
    }
    
    
    func test_UnitTestingBootcampViewModel_downloadWithCombine_shouldReturnItems2() {
        //Given
        let items = [UUID().uuidString, UUID().uuidString,UUID().uuidString,UUID().uuidString,UUID().uuidString]
        let dataService: NewDataServiceProtocol = NewMockDataService(items: items)
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random(), dataService: dataService)
        
        
        //When
        let expectation = XCTestExpectation(description: "Should return items after a sec")
        vm.$dataArray
            .dropFirst() //drop the first publish, dataArray at very init is going to publish a blank array as soon as we set values
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
       
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0) //greater than 0
        XCTAssertEqual(vm.dataArray.count, items.count)
       
    }
}
