//
//  LastFMApp.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import SwiftUI
import Swinject

@main
struct LastFMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    private var resolver: Resolver {
        appDelegate.dependencyManager.resolver
    }
    
    var body: some Scene {
        WindowGroup { () -> TopArtistsView<TopArtistsViewModel> in 
            return resolver.resolve(TopArtistsView<TopArtistsViewModel>.self)!
        }
    }
}
