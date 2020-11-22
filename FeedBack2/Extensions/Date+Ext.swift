//
//  Date+Ext.swift
//  FeedBack
//
//  Created by Julian Gierl on 22.11.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
