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
    
    var favouriteViewModel:FavouriteViewModel
    
    @Published var isSearchViewPresented = false
    @Published var isMovieDetailPresented = false
    
    @Published var searchResults: [Movie] = []
    
    @Published var searchText = ""
    
    init(favouriteViewModel: FavouriteViewModel) {
        self.favouriteViewModel = favouriteViewModel
    }
    
    
    func addDislike(movie:Movie) {
        movieStore.saveDisliked(movie: movie)
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
            
            var filteredResults = movies
            
            if let disliked = self.movieStore.fetchDisliked() {
                filteredResults = movies.filter { movie in
                    return !disliked.contains(movie)
                }
            }
            
           let favourites = self.movieStore.fetchFavoriteMovies()
            
            if favourites.count > 0 {
                filteredResults = filteredResults.map { movie in
                    var updatedMovie = movie
                    updatedMovie.isFavorite = favourites.contains(where: { $0.name == movie.name })
                    return updatedMovie
                }
            }
            
            DispatchQueue.main.async {
                self.searchResults = filteredResults
            }
            
        })
    }
    
    func cancelSearch() {
        favouriteViewModel.isSearchViewPresented = false
    }
}
