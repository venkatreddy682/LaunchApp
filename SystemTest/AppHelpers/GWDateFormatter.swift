//
//  GWDateFormatter.swift
//  SystemTest
//
//  Created by apple on 03/09/22.
//

import Foundation

let DEVICE_LOCALE = Locale.current   //Locale(identifier: "en_US_POSIX")

class GWDateFormatter {
    static let shared = GWDateFormatter()
    
    lazy var iso8601UserTimeZone: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        formatter.timeZone = TimeZone.current
        formatter.locale = DEVICE_LOCALE
        return formatter
    }()
    
    lazy var MonthDayYear: DateFormatter = {
        let monthFirstShortDate = DateFormatter()
        monthFirstShortDate.timeZone = TimeZone.current
        monthFirstShortDate.locale = DEVICE_LOCALE
        monthFirstShortDate.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        return monthFirstShortDate
    }()

}
