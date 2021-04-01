//
//  Country.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import Foundation

enum Country: String, CaseIterable {
    case spain
    case ukraine
    case ireland
    
    var title: String {
        switch self {
        case .spain: return "Spain"
        case .ukraine: return "Ukraine"
        case .ireland: return "Ireland"
        }
    }
}
