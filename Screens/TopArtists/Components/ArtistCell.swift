//
//  ArtistCell.swift
//  LastFM
//
//  Created by Timur Mustafaev on 29.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListRow: View {
    
    private let viewModel: RowViewModel
    
    init(viewModel: RowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top){
            WebImage(url: viewModel.image)
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(Color(.lightGray))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 75, height: 75, alignment: .leading)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    
                Text("Listeners: \(viewModel.listeners)")
                    .font(.callout)
                    .foregroundColor(.gray)
                
            }
            Spacer()
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
    }
    
}

struct ArtistCell_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(viewModel: RowViewModel(id: "id", name: "Adele", listeners: "2314", image: URL(string: "https://lastfm.freetls.fastly.net/i/u/770x0/1a1cf29db79941eea25f7e2c0d3deeb6.jpg#1a1cf29db79941eea25f7e2c0d3deeb6")!))
    }
}
