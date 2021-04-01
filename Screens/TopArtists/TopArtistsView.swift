//
//  TopArtistsView.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import SwiftUI

struct TopArtistsView<ViewModel: TopArtistsViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @State private var showingSheet = false
    
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
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        toolBarContent
                    }
                })
                .onAppear(perform: viewModel.didLoad)
        }
        
    }
    
    var toolBarContent: some View {
        VStack {
            Button(action: {
                showingSheet = true
            }, label: {
                Text(viewModel.country)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }).actionSheet(isPresented: $showingSheet, content: {
                let buttons = Country.allCases.map { country -> ActionSheet.Button in
                    ActionSheet.Button.default(Text(country.title)) {
                        viewModel.didChange(country: country)
                    }
                }
                return ActionSheet(title: Text("Select Country"), message: nil, buttons: buttons + [.cancel()])
            })
            Image(systemName:"chevron.compact.down")
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
