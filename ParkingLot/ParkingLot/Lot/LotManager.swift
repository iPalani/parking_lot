//
//  LotManager.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation

final class LotManager {
    
    var service: LotServiceProtocol
    
    var lots: [Lot] = []
    
    init?(service: LotServiceProtocol?) {
        guard service != nil else {
            return nil
        }
        self.service = service!
        getLots()
    }
    
    func getLots() {
        lots = self.service.fetchLots()
    }
    
    func lot(forCategory category: LotCategory) -> Lot? {
        guard lots.count > 0 else {
            return nil
        }
        guard let index = self.lots.firstIndex(where: { $0.category == category }) else {
            return nil
        }
        return self.lots[index]
    }
    
    func availableSlot(category: LotCategory) -> Int? {
        guard let lot = lot(forCategory: category) else {
            return nil
        }
        guard lot.available > 0 else {
            return nil
        }
        return lot.slotMap.sorted(by: {$0.key < $01.key}).filter({ $0.value == false }).first?.key ?? nil
    }
    
    func doPark(category: LotCategory, slot: Int) {
        guard var lot = lot(forCategory: category) else {
            return
        }
        guard lot.slotMap.count >= slot else {
            return
        }
        lot.slotMap[slot] = true
        lot.occupied += 1
    }
    
    func doUnPark(category: LotCategory, slot: Int) {
        guard var lot = lot(forCategory: category) else {
            return
        }
        guard lot.slotMap.count >= slot else {
            return
        }
        lot.slotMap[slot] = false
        lot.occupied -= 1
    }
}
