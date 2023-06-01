//
//  ListView.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI
import Kingfisher

struct SearchListItem: View {
    
    var movie: Movie
    
    var disLikeAction:(() -> Void)?
    var favouriteAction:(() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(movie.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: movie.isFavorite ?? false ? "heart.fill" : "heart")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 22, height: 19)
                    .onTapGesture {
                        favouriteAction?()
                    }
            }
            KFImage(movie.imageURL)
                .placeholder{ProgressView()}
                .resizable()
                .background(Color.gray)
                .cornerRadius(10.0)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
            
            HStack {
                Text(String(format: "Rating: %.1f", movie.rating))
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
                
                if !(movie.isFavorite ?? false) {
                    Text("Don't want to see again")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .onTapGesture {
                            disLikeAction?()
                        }
                }
                
                
            }
            .padding(.top, 5)
            
            Text(movie.description)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.darkGray))
                .padding(.top, 5)
        }
        .listRowSeparator(.hidden)
        
    }
}


struct SearchListItem_Previews: PreviewProvider {
    static var previews: some View {
        return SearchListItem(movie: Movie(name: "Test Movie", rating: 5.0, imageName: "", description: "Test Description"))
            .padding()
            .previewDisplayName("Default preview 2")
    }
}
