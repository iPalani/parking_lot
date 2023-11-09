//
//  DatabaseManager.swift
//  ParkingLot
//
//  Created by Palani Ram on 09/11/23.
//

import Foundation
import SQLite3

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let dbPath: String = "ParkingLot.sqlite"
    var db:OpaquePointer?

    private init() {
        db = openDatabase()
        createTicketTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            return nil
        } else {
            return db
        }
    }

    func createTicketTable() {
        let queryString = """
                        CREATE TABLE IF NOT EXISTS
                        ticket(
                            Id INTEGER PRIMARY KEY AUTOINCREMENT,
                            VehicleRegistrationNumber TEXT,
                            Vehicle TEXT,
                            LotCategory TEXT,
                            Slot INTEGER,
                            ParkAt INTEGER,
                            UnParkAt INTEGER
                        );
                        """
        create(table: "Ticket", queryString: queryString)
    }
    
    func create(table name: String, queryString: String) {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("\(name) table has been created.")
            } else {
                print("\(name) table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    @discardableResult
    func insert(ticket: Ticket) -> Bool {
        var status = false
        let queryString = "INSERT INTO ticket ( VehicleRegistrationNumber, Vehicle, LotCategory, Slot, ParkAt, UnParkAt) VALUES ( ?, ?, ?, ?, ?, ?);"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (ticket.vehicleRegistrationNumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 2, (ticket.vehicle.rawValue as NSString).utf8String, -1, nil)
            sqlite3_bind_text(queryStatement, 3, (ticket.lotCategory.rawValue as NSString).utf8String, -1, nil)
            sqlite3_bind_int(queryStatement, 4, Int32(ticket.slot))
            sqlite3_bind_int(queryStatement, 5, Int32(ticket.parkAt.timeIntervalSince1970))
            sqlite3_bind_int(queryStatement, 6, Int32(ticket.unParkAt?.timeIntervalSince1970 ?? 0))
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                status = true
            }
        }
        sqlite3_finalize(queryStatement)
        return status
    }
    
    func fetchTicket(queryStatement: OpaquePointer?) -> Ticket {
        return Ticket(
            id: Int(sqlite3_column_int(queryStatement, 0)),
            vehicleRegistrationNumber: String(describing: String(cString: sqlite3_column_text(queryStatement, 1))),
            vehicle: VehicleType(rawValue: String(describing: String(cString: sqlite3_column_text(queryStatement, 2))))!,
            lotCategory: LotCategory(rawValue: String(describing: String(cString: sqlite3_column_text(queryStatement, 3))))!,
            slot: Int(sqlite3_column_int(queryStatement, 4)),
            parkAt: Date(timeIntervalSince1970: Double(sqlite3_column_int(queryStatement, 5))),
            unParkAt: sqlite3_column_int(queryStatement, 6) == 0 ? nil : Date(timeIntervalSince1970: Double(sqlite3_column_int(queryStatement, 6)))
        )
    }
    
    func read() -> [Ticket] {
        let queryString = "SELECT * FROM ticket;"
        var queryStatement: OpaquePointer? = nil
        var tickets : [Ticket] = []
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                tickets.append(fetchTicket(queryStatement: queryStatement))
            }
        }
        sqlite3_finalize(queryStatement)
        return tickets
    }
    
    func readTicket(forVehicle registerNumber: String) -> Ticket? {
        let queryString = "SELECT * FROM ticket WHERE VehicleRegistrationNumber = \"\(registerNumber)\" AND UnParkAt = 0;"
        var queryStatement: OpaquePointer? = nil
        var ticket: Ticket?
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                ticket = fetchTicket(queryStatement: queryStatement)
            }
        }
        sqlite3_finalize(queryStatement)
        return ticket
    }
    
    func update(unParkTime: Date, forVehicle registerNumber: String) -> Bool {
        var status = false
        let queryString = "UPDATE ticket SET UnParkAt = \(Int32(unParkTime.timeIntervalSince1970)) WHERE VehicleRegistrationNumber = \"\(registerNumber)\";"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                status = true
            }
        }
        sqlite3_finalize(queryStatement)
        return status
    }
    
    func deleteAll() {
        let queryString = "DELETE FROM ticket;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
            } else {
            }
        }
        sqlite3_finalize(queryStatement)
    }
}
