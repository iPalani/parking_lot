//
//  Model.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation

class Lot {
    var category: LotCategory
    var uptoFourHours: Int = 0
    var uptoTwelveHours: Int = 0
    var afterTwelveHours: Int = 0
    var total: Int = 0
    var occupied: Int = 0
    var available: Int {
        return total - occupied
    }
    var slotMap: [Int: Bool] = [:]
    init(category: LotCategory) {
        self.category = category
    }
}

struct Ticket: Identifiable {
    var id: Int
    var vehicleRegistrationNumber: String
    var vehicle: VehicleType
    var lotCategory: LotCategory
    var slot: Int
    var parkAt: Date
    var unParkAt: Date?
}
