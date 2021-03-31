//
//  TopArtistsView.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import SwiftUI

struct TopArtistsView<ViewModel: TopArtistsViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    private var router: TopArtistViewRouterType
    
    init(viewModel: ViewModel, router: TopArtistViewRouterType) {
        self.viewModel = viewModel
        self.router = router
    }
    
    var body: some View {
        NavigationView {
            contentView
                .navigationBarTitle("Top Artists")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: viewModel.didLoad)
        }
        
    }
    
    private var contentView: AnyView {
        switch viewModel.state {
        case .loading:
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .large))
        case .data(let rows):
            return AnyView(listView(rows: rows))
        case .error:
            return AnyView(Text("Got error during request"))
        }
    }
    
    private func listView(rows: [RowViewModel]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(rows) { model in
                    NavigationLink(destination: LazyView(router.artistDetailsView(for: model.name)),
                                   label: { ListRow(viewModel: model) })
                        .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
}

struct TopArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TopArtistsViewModel(repository: TopArtistsRepository(networkService: NetworkService(), storageService: StorageService(), reachability: ReachabilityService()))
        return TopArtistsView(viewModel: viewModel, router: TopArtistViewRouterMock())
    }
}
