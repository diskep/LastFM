//
//  LazyView.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: some View {
        build()
    }
}
