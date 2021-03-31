//
//  Combine+.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 31.03.2021.
//

import Combine

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}

