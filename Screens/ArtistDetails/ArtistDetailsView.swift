//
//  ArtistDetailsView.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import SwiftUI

struct ArtistDetailsView<ViewModel: ArtistDetailsViewModelType>: View {
    @ObservedObject private var viewModel: ViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .navigationTitle(viewModel.artist)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                mode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }))
            .onAppear(perform: viewModel.didLoad)
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
                // uncomment these lines if you need large album image with plays count
                // bun i don't think we need it here as each row shows same info
                // if let selectedAlbum = viewModel.selectedAlbum {
                //    AlbumView(viewModel: selectedAlbum)
                //       .padding([.top, .bottom], 16)
                // }
                ForEach(rows) { model in
                    ListRow(viewModel: model)
                        .onTapGesture {
                            viewModel.didSelect(albumId: model.id)
                        }
                }
            }
        }
    }
}

struct ArtistDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailsView(viewModel: ArtistDetailsViewModel(artist: "Eminem",
                                                            repository: ArtistDetailsRepository(networkService: NetworkService(),
                                                                                                storageService: StorageService(),
                                                                                                reachability: ReachabilityService())))
    }
}
