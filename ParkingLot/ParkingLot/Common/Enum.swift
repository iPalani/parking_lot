//
//  Enum.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation

enum LotCategory: String {
    case twoWheeler
    case fourWheelerLight
    case fourWheelerHeavy
}

enum VehicleType: String {
    case motorcycle
    case scooter
    case car
    case suv
    case bus
    case truck
    var category: LotCategory {
        switch self {
            case .motorcycle, .scooter: return .twoWheeler
            case .car, .suv: return .fourWheelerLight
            case .bus, .truck: return .fourWheelerHeavy
        }
    }
}
