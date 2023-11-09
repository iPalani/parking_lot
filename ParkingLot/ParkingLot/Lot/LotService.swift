//
//  LotService.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation

class LotService: LotServiceProtocol {
    init() {}
    func fetchLots() -> [Lot] {
        return []
    }
}

class LotMockService: LotServiceProtocol {
    init() {
    }
    func fetchLots() -> [Lot] {
        let lot = Lot(category: .twoWheeler)
        lot.uptoFourHours = 30
        lot.uptoTwelveHours = 60
        lot.afterTwelveHours = 100
        lot.total = 5
        lot.occupied = 3
        lot.slotMap = [1: true, 2: true, 3: false, 4: false, 5: true]
        return [lot]
    }
}
