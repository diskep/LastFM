//
//  Foundation+.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation
import RealmSwift

// MARK: - NumberFormatter
extension NumberFormatter {
    
    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }() // to avoid of unnesessary allocations for each iteration
    
    static func format(listeners: String) -> String {
        guard let count = Int(listeners) else { return listeners }
        return format(number: count)
    }
    
    static func format(number: Int) -> String {
        return formatter.string(from: number as NSNumber) ?? String(number)
    }
    
}

// MARK: - RealmOptionalType
extension URL: RealmOptionalType {}
