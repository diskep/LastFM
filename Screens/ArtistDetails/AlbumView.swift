//
//  AlbumDetailsView.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumView: View {
    private let viewModel: AlbumViewModel
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            imageView
            Text(viewModel.name)
                .font(.system(size: 25, weight: .semibold))
                .shadow(radius: 2)
            Text(viewModel.playsCount)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.gray)
        }
    }
    
    var imageView: some View {
        HStack {
            Spacer()
            let imageSize = UIScreen.main.bounds.size.width - 24
            WebImage(url: viewModel.imageUrl)
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(Color(.lightGray))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize, height: imageSize,
                       alignment: .center)
                .cornerRadius(8)
                .shadow(radius: 4)
            Spacer()
        }
    }
}

struct Album_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(viewModel: AlbumViewModel(name: "Some Album Name", imageUrl: URL(string: "https://lastfm.freetls.fastly.net/i/u/300x300/8d9dc419f12f09abe77d3ba7cbecad1f.png")!, playsCount: "10,000"))
    }
}
