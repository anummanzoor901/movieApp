//
//  FavouriteViewModel.swift
//  MyMovieApp
//
//  Created by Mehtab on 01/06/2023.
//

import Foundation

class FavouriteViewModel: ObservableObject {
    
    @Published var isSearchViewPresented: Bool
    @Published var isMovieDetailPresented: Bool
    
    var searchText: String
    @Published var favoriteMovies: [Movie]
    let movieStore: MovieStore
    
    init(isSearchViewPresented: Bool, isMovieDetailPresented: Bool, searchText: String, favoriteMovies: [Movie], movieStore: MovieStore) {
        self.isSearchViewPresented = isSearchViewPresented
        self.isMovieDetailPresented = isMovieDetailPresented
        self.searchText = searchText
        self.favoriteMovies = favoriteMovies
        self.movieStore = movieStore
    }
    
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
