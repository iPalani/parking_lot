//
//  TicketService.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation

class TicketService: TicketServiceProtocol {
    init() {}
    func fetchTickets() -> [Ticket] {
        let tickets = DatabaseManager.shared.read()
        return tickets
    }
}

class TicketMockService: TicketServiceProtocol {
    
    init() {
        insertTickets()
    }
    
    func insertTickets() {
        DatabaseManager.shared.deleteAll()
        let ticket1 = Ticket(
            id: 1,
            vehicleRegistrationNumber: "IN1111",
            vehicle: .motorcycle,
            lotCategory: .twoWheeler,
            slot: 1,
            parkAt: .now.addingTimeInterval(-(3 * 3600))
        )

        let ticket2 = Ticket(
            id: 2,
            vehicleRegistrationNumber: "IN2222",
            vehicle: .motorcycle,
            lotCategory: .twoWheeler,
            slot: 2,
            parkAt: .now.addingTimeInterval(-(8 * 3600))
        )
        let ticket3 = Ticket(
            id: 3,
            vehicleRegistrationNumber: "IN3333",
            vehicle: .scooter,
            lotCategory: .twoWheeler,
            slot: 5,
            parkAt: .now.addingTimeInterval(-(15 * 3600))
        )
        DatabaseManager.shared.insert(ticket: ticket1)
        DatabaseManager.shared.insert(ticket: ticket2)
        DatabaseManager.shared.insert(ticket: ticket3)
    }
    
    func fetchTickets() -> [Ticket] {
        let tickets = DatabaseManager.shared.read()
        return tickets
    }
}
