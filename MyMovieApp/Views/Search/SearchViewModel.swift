//
//  SearchViewModel.swift
//  MyMovieApp
//
//  Created by Mehtab on 02/06/2023.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    
    var movieStore = MovieStore()
    var remoteMovieLoader = RemoteMoviesLoader()
    
    private var dislikeMovie: [Movie] = []
    
 //   private var favoriteMovies: [Movie] = []
    
    @Published var isSearchViewPresented = false
    @Published var isMovieDetailPresented = false
    
    @Published var searchResults: [Movie] = []
    
    @Published var searchText = ""
    
    func addDislike(movie:Movie) {
        movieStore.saveDisliked(movie: movie)
        dislikeMovie.append(movie)
        // Remove the disliked movie from the search results
        if let index = searchResults.firstIndex(of: movie) {
            searchResults.remove(at: index)
        }
    }
    
    func removefavoriteMovie(movie: Movie) {
        movieStore.delete(movie: movie)
        if let index = searchResults.firstIndex(of: movie) {
        //    favoriteMovies.remove(at: index)
            searchResults[index].isFavorite = false
        }
    }
    
    func addFavourite(movie: Movie) {
        movieStore.saveFavourite(movie: movie)
       // favoriteMovies.append(movie)
        if let index = searchResults.firstIndex(of: movie) {
            searchResults[index].isFavorite = true
        }
    }

    func searchMovies() {
        remoteMovieLoader.loadMovies(from: searchText, completion: { movies in
            var filteredResults = movies.filter { movie in
                return !self.dislikeMovie.contains { $0.name == movie.name }
            }
            filteredResults = filteredResults.map { movie in
                var updatedMovie = movie
                updatedMovie.isFavorite = self.movieStore.fetchFavourite(by: movie.name) != nil
                return updatedMovie
            }
            
            DispatchQueue.main.async {
                self.searchResults = filteredResults
            }
            
        })
    }
    
//    func isFavourite(movie:Movie) -> Bool {
//        if favoriteMovies.contains(where: { $0.name == movie.name }) {
//            return true
//        }
//        return false
//    }
    
    
    func loadDislikedMovies() {
        dislikeMovie = movieStore.fetchDisliked() ?? []
    }
}
