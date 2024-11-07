//
//  UserDefaults+Extensions.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 06/11/24.
//

import Foundation

extension UserDefaults {
    // Guarda la fecha de último reporte para una zona específica
    func setLastReportDate(forZoneId zoneId: UUID, date: Date) {
        set(date, forKey: "lastReportDate_\(zoneId.uuidString)")
    }
    
    // Recupera la fecha de último reporte para una zona específica
    func getLastReportDate(forZoneId zoneId: UUID) -> Date? {
        return object(forKey: "lastReportDate_\(zoneId.uuidString)") as? Date
    }
}
