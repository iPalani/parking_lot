//
//  TicketManagerTests.swift
//  ParkingLotTests
//
//  Created by Palani Ram on 09/11/23.
//

import XCTest
@testable import ParkingLot

final class TicketManagerTests: XCTestCase {
    
    var ticketManager: TicketManager?
    
    override func setUpWithError() throws {
        let manager = TicketManager(lotService: LotMockService(), ticketService: TicketMockService())
        let unwrapedManager = try XCTUnwrap(manager)
        ticketManager = unwrapedManager
        ticketManager!.fetchDetails()
    }
    
    override func tearDownWithError() throws {
        ticketManager = nil
    }
    
    func testTicketManagerInitializationSuccess() {
        let successCase = TicketManager(lotService: LotMockService(), ticketService: TicketMockService())
        XCTAssertNotNil(successCase)
    }
    
    func testTicketManagerInitializationFailure() {
        let failureCase_1 = TicketManager(lotService: nil, ticketService: TicketMockService())
        XCTAssertNil(failureCase_1)
        let failureCase_2 = TicketManager(lotService: LotMockService(), ticketService: nil)
        XCTAssertNil(failureCase_2)
    }
    
    func testFetchDetails() {
        XCTAssertEqual(ticketManager!.lots.count, 1)
        XCTAssertEqual(ticketManager!.tickets.count, 3)
    }
    
    func testParkSuccess() throws {
        let ticket = ticketManager!.park(vehicle: "IN4444", type: .scooter)
        let unwrapedTicket = try XCTUnwrap(ticket)
        XCTAssertEqual(unwrapedTicket.vehicleRegistrationNumber, "IN4444")
        XCTAssertEqual(unwrapedTicket.lotCategory, .twoWheeler)
        XCTAssertEqual(unwrapedTicket.slot, 3)
        XCTAssertEqual(ticketManager!.tickets.count, 4)
    }
    
    func testParkFailure() throws {
        let _ = ticketManager!.park(vehicle: "IN4444", type: .scooter)
        let _ = ticketManager!.park(vehicle: "IN5555", type: .scooter)
        let ticket = ticketManager!.park(vehicle: "IN6666", type: .scooter)
        XCTAssertNil(ticket, "No space available")
    }
    
    func testUnParkSuccess() throws {
        let ticket = ticketManager!.unpark(vehicle: "IN3333")
        let unwrapedTicket = try XCTUnwrap(ticket)
        XCTAssertEqual(unwrapedTicket.vehicleRegistrationNumber, "IN3333")
        XCTAssertEqual(unwrapedTicket.lotCategory, .twoWheeler)
        XCTAssertEqual(unwrapedTicket.slot, 5)
    }
    
    func testUnParkFailure() throws {
        let ticket = ticketManager!.unpark(vehicle: "XYZ")
        XCTAssertNil(ticket)
    }
    
    func testParkingDurationInHours() {
        let parkingHours_in1111 = ticketManager!.parkingDurationInHours(ticketManager!.tickets[0])
        XCTAssertEqual(parkingHours_in1111, 3)
        let parkingHours_in2222 = ticketManager!.parkingDurationInHours(ticketManager!.tickets[1])
        XCTAssertEqual(parkingHours_in2222, 8)
    }
    
    func testFeesSuccess() {
        let fees_in1111 = ticketManager!.fees(forVehicle: "IN1111")
        XCTAssertEqual(fees_in1111, 90)
        let fees_in2222 = ticketManager!.fees(forVehicle: "IN2222")
        XCTAssertEqual(fees_in2222, 480)
        let fees_in3333 = ticketManager!.fees(forVehicle: "IN3333")
        XCTAssertEqual(fees_in3333, 1500)
    }
    
    func testFeesFailure() {
        let fees = ticketManager!.fees(forVehicle: "XYZ")
        XCTAssertEqual(fees, 0)
    }
}
