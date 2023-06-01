//
//  FavouriteMovieListItem.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI
import CoreData

struct FavouriteMovieListItem: View {
    
    var movie: Movie
    var favouriteAction:(() -> Void)?

    var viewContext: NSManagedObjectContext = PersistenceController.shared.context
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(movie.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "heart.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 25, height: 22)
                    .onTapGesture {
                        favouriteAction?()
                    }
            }
            
            if let imageURL = movie.imageURL {
                            AsyncImage(url: imageURL, scale: 1.0) { image in
                                image
                                    .resizable()
                                    .cornerRadius(10.0)
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                            } placeholder: {
                                // Placeholder image or activity indicator while loading
                                Image("godfather")
                                    .resizable()
                                    .cornerRadius(10.0)
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                            }
                        }
            
            
            Text(String(format: "Rating: %.1f", movie.rating))
                .font(.subheadline)
                .foregroundColor(.orange)
                .padding(.top, 5)
            
            Text(movie.description)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.darkGray))
                .padding(.top, 5)
        }
        .listRowSeparator(.hidden)
        
    }

}

struct FavouriteMovieListItem_Previews: PreviewProvider {
    static var previews: some View {
        return FavouriteMovieListItem(movie: Movie(name: "Test Movie", rating: 5.0, imageName: "", description: "Test Description"))
            .padding()
            .previewDisplayName("Default preview 2")
    }
}
