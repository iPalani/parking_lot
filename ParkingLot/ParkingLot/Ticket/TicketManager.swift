//
//  TicketManager.swift
//  ParkingLot
//
//  Created by Palani Ram on 05/11/23.
//

import Foundation

final class TicketManager {
    
    var lotService: LotServiceProtocol
    var lotManager: LotManager
    var ticketService: TicketServiceProtocol

    var tickets: [Ticket] = []
    var lots: [Lot] = []
    
    init?(lotService: LotServiceProtocol?, ticketService: TicketServiceProtocol?) {
        guard (lotService != nil && ticketService != nil) else {
            return nil
        }
        guard let lotManager = LotManager(service: lotService!) else {
            return nil
        }
        self.lotService = lotService!
        self.lotManager = lotManager
        self.ticketService = ticketService!
    }
    
    func fetchDetails() {
        self.lots = self.lotService.fetchLots()
        self.tickets = self.ticketService.fetchTickets()
    }
    
    func park(vehicle registrationNumber: String, type: VehicleType) -> Ticket? {
        guard let slot = lotManager.availableSlot(category: type.category) else {
            return nil
        }
        let ticket = Ticket(
            id: self.tickets.count + 1,
            vehicleRegistrationNumber: registrationNumber,
            vehicle: type,
            lotCategory: type.category,
            slot: slot,
            parkAt: .now
        )
        let isInserted = DatabaseManager.shared.insert(ticket: ticket)
        guard isInserted else {
            print("Could not issue ticket")
            return nil
        }
        self.lotManager.doPark(category: type.category, slot: slot)
        self.tickets = self.ticketService.fetchTickets()
        return ticket
    }
    
    func unpark(vehicle registrationNumber: String) -> Ticket? {
        guard let ticket = DatabaseManager.shared.readTicket(forVehicle: registrationNumber) else {
            return nil
        }
        let isUpdated = DatabaseManager.shared.update(unParkTime: .now, forVehicle: registrationNumber)
        guard isUpdated else {
            print("Could not update ticket")
            return nil
        }
        self.lotManager.doUnPark(category: ticket.lotCategory, slot: ticket.slot)
        self.tickets = self.ticketService.fetchTickets()
        return ticket
    }
    
    func parkingDurationInHours(_ ticket: Ticket) -> Int {
        guard let unParkAt = ticket.unParkAt else {
            return Calendar.current.dateComponents([.hour], from: ticket.parkAt, to: .now).hour ?? 0
        }
        return Calendar.current.dateComponents([.hour], from: ticket.parkAt, to: unParkAt).hour ?? 0
    }
    
    func fees(forVehicle registrationNumber: String) -> Int {
        guard let ticket = DatabaseManager.shared.readTicket(forVehicle: registrationNumber) else {
            return 0
        }
        guard let lot = self.lotManager.lot(forCategory: ticket.lotCategory) else {
            return 0
        }
        let duration = parkingDurationInHours(ticket)
        switch duration {
            case 0..<4:
            return (lot.uptoFourHours * (duration == 0 ? 1 : duration))
            case 4..<12:
                return (lot.uptoTwelveHours * duration)
            default:
                return (lot.afterTwelveHours * duration)
        }
    }
}
