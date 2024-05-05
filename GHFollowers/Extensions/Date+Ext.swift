//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by MANAS VIJAYWARGIYA on 05/05/24.
//

import Foundation

extension Date {
  
  func convertToMonthYearFormat() -> String {
    return formatted(.dateTime.month(.abbreviated).year())
  }
  
//  func convertToMonthYearFormat1() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MMM yyyy"
//    return dateFormatter.string(from: self)
//  }
}
