//
//  UserDefaults+Extensions.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 06/11/24.
//

import Foundation

extension UserDefaults {
    // Storing the date of the last report added in a specific zone
    func setLastReportDate(forZoneId zoneId: UUID, date: Date) {
        set(date, forKey: "lastReportDate_\(zoneId.uuidString)")
    }
    
    // Recovering the date of the last report added in a specific zone
    func getLastReportDate(forZoneId zoneId: UUID) -> Date? {
        return object(forKey: "lastReportDate_\(zoneId.uuidString)") as? Date
    }
}
