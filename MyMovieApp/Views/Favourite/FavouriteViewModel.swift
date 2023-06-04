//
//  FavouriteViewModel.swift
//  MyMovieApp
//
//  Created by Mehtab on 01/06/2023.
//

import Foundation

class FavouriteViewModel: ObservableObject {
    
    @Published var isSearchViewPresented = false
    @Published var isMovieDetailPresented = false
    
    var searchText = ""
    @Published var favoriteMovies: [Movie] = []
    let movieStore = MovieStore()
    
    func fetchFavouriteMovies() {
        favoriteMovies = movieStore.fetchFavoriteMovies()
        
    }
    
    func removeFavourite(movie: Movie) {
        if let index = favoriteMovies.firstIndex(of: movie) {
            movieStore.delete(movie: movie)
            favoriteMovies.remove(at: index)
        }
    }
    
    func presentSearchView() {
        isSearchViewPresented = true
    }
    
    func presentDetailView() {
        isMovieDetailPresented = true
    }
}
