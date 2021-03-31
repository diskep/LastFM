//
//  DependencyManager.swift
//  LastFM
//
//  Created by Timur Mustafaev on 29.03.2021.
//

import Swinject

final class DependencyManager {
    
    private let assembler: Assembler
    
    init() {
        assembler = Assembler([TopArtistFlowAssembly(), ServicesAssembly()])
    }
    
    var resolver: Resolver {
        assembler.resolver
    }
}
