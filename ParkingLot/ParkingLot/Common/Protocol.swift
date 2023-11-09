//
//  Protocol.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation

protocol LotServiceProtocol {
    func fetchLots() -> [Lot]
}

protocol TicketServiceProtocol {
    func fetchTickets() -> [Ticket]
}
