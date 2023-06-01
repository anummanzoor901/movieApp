//
//  DetailMovieView.swift
//  MyMovieApp
//
//  Created by Mehtab on 12/05/2023.
//

import SwiftUI
struct MovieDetailView<Content: View>: View {
    
    let content: Content
    
    var body: some View {
        VStack {
            content
            Spacer()
        }
        .padding()
    }
}

//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let movies: [Movie] = getMovies()
//        MovieDetailView(content: SearchListItem(movie: .constant(Movie(name: "Example Movie", rating: 8.5, imageName: "exampleImage", description: "This is an example movie.", isFavorite: true, isDisliked: false)), movies: .constant(movies)))
//    }
//}
