//
//  LotManagerTests.swift
//  ParkingLotTests
//
//  Created by Palani Ram on 09/11/23.
//

import XCTest
@testable import ParkingLot

final class LotManagerTests: XCTestCase {
    
    var lotManager: LotManager!
    
    override func setUpWithError() throws {
        let manager = LotManager(service: LotMockService())
        let unwrapedManager = try XCTUnwrap(manager)
        lotManager = unwrapedManager
        lotManager!.getLots()
    }
    
    override func tearDownWithError() throws {
        lotManager = nil
    }
    
    func testLotManagerInitializationSuccess() {
        let successCase = LotManager(service: LotMockService())
        XCTAssertNotNil(successCase)
    }
    
    func testLotManagerInitializationFailure() {
        let failureCase = LotManager(service: nil)
        XCTAssertNil(failureCase)
    }
    
    func testGetLots() {
        XCTAssertEqual(lotManager!.lots.count, 1)
    }
    
    func testLot() throws {
        let lot = lotManager.lot(forCategory: .twoWheeler)
        let unwrapedLot = try XCTUnwrap(lot)
        XCTAssertEqual(unwrapedLot.total, 5)
        XCTAssertEqual(unwrapedLot.occupied, 3)
        XCTAssertEqual(unwrapedLot.available, 2)
    }
    
    func testAvailableSlot() {
        let slot = lotManager.availableSlot(category: .twoWheeler)
        XCTAssertNotNil(slot)
        XCTAssertNotEqual(slot, 5)
        XCTAssertEqual(slot, 3)
    }
    
    func testDoParkSuccess() throws {
        let slot = 4
        lotManager.doPark(category: .twoWheeler, slot: slot)
        let lot = lotManager.lot(forCategory: .twoWheeler)
        let unwrapedLot = try XCTUnwrap(lot)
        XCTAssertTrue(unwrapedLot.slotMap[slot]!)
        XCTAssertEqual(unwrapedLot.occupied, 4)
    }
    
    func testDoParkFailure() throws {
        let slot = 100
        lotManager.doPark(category: .twoWheeler, slot: slot)
        let lot = lotManager.lot(forCategory: .twoWheeler)
        let unwrapedLot = try XCTUnwrap(lot)
        XCTAssertNil(unwrapedLot.slotMap[slot])
        XCTAssertEqual(unwrapedLot.occupied, 3)
    }
    
    func testDoUnParkSuccess() throws {
        let slot = 5
        lotManager.doUnPark(category: .twoWheeler, slot: slot)
        let lot = lotManager.lot(forCategory: .twoWheeler)
        let unwrapedLot = try XCTUnwrap(lot)
        XCTAssertFalse(unwrapedLot.slotMap[slot]!)
        XCTAssertEqual(unwrapedLot.occupied, 2)
    }
    
    func testDoUnParkFailure() throws {
        let slot = 100
        lotManager.doPark(category: .twoWheeler, slot: slot)
        let lot = lotManager.lot(forCategory: .twoWheeler)
        let unwrapedLot = try XCTUnwrap(lot)
        XCTAssertNil(unwrapedLot.slotMap[slot])
        XCTAssertEqual(unwrapedLot.occupied, 3)
    }
}
