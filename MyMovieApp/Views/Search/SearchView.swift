//
//  SearchView.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var isSearchViewPresented: Bool
    @Binding var favoriteMovies: [Movie] // Add favoriteMovies as a binding
    @State private var isMovieDetailPresented = false
    @State private var searchResults: [Movie] = []
    @State var dislikeMovie: [Movie] = []
    @State private var searchText = ""
    
    
    
    let movieStore = MovieStore()
    let remoteMovieLoader = RemoteMoviesLoader()
    
    @State private var showSearchResults = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: searchText) { text in
                            if text.count > 3 {
                                searchMovies() // Call searchMovies() when the text changes
                            }
                            
                        }
                    
                    Button(action: {
                        isSearchViewPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                        
                    }
                }
                .padding()
                
                if searchResults.isEmpty {
                    Spacer()
                    Text("No results found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(searchResults, id: \.self) { movie in
                            
                            SearchListItem(movie: movie, disLikeAction: {
                                addDislike(movie: movie)
                            }, favouriteAction: {
                                if movie.isFavorite == true {
                                    removefavoriteMovie(movie: movie)
                                }
                                else {
                                    addFavourite(movie: movie)
                                }
                            })
                            .onTapGesture {
                                isMovieDetailPresented = true
                                
                            }
                            .sheet(isPresented: $isMovieDetailPresented) {
                                MovieDetailView(content: SearchListItem(movie: movie))
                            }
                            .listRowSeparator(.hidden)
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                Spacer()
            }
            .navigationBarTitle("Search")
            .onDisappear {
                searchText = ""
            }
        }
        
        .onAppear {
            loadDislikedMovies()
        }
        
    }
    
    func addDislike(movie:Movie) {
        movieStore.saveDisliked(movie: movie)
        dislikeMovie.append(movie)
        // Remove the disliked movie from the search results
        if let index = searchResults.firstIndex(of: movie) {
            searchResults.remove(at: index)
        }
    }
    
    private func removefavoriteMovie(movie: Movie) {
        movieStore.delete(movie: movie)
        if let index = searchResults.firstIndex(of: movie) {
            favoriteMovies.remove(at: index)
            searchResults[index].isFavorite = false
        }
    }
    
    func addFavourite(movie: Movie) {
        movieStore.saveFavourite(movie: movie)
        favoriteMovies.append(movie)
        if let index = searchResults.firstIndex(of: movie) {
            searchResults[index].isFavorite = true
        }
    }

    
    private func searchMovies() {
        remoteMovieLoader.loadMovies(from: searchText, completion: { movies in
            var filteredResults = movies.filter { movie in
                return !dislikeMovie.contains { $0.name == movie.name }
            }
            filteredResults = filteredResults.map { movie in
                var updatedMovie = movie
                updatedMovie.isFavorite = isFavourite(movie: movie)
                return updatedMovie
            }
            searchResults = filteredResults
        })
    }
    
    private func isFavourite(movie:Movie) -> Bool {
        if favoriteMovies.contains(where: { $0.name == movie.name }) {
            return true
        }
        return false
    }
    
    
    private func loadDislikedMovies() {
        dislikeMovie = movieStore.fetchDisliked() ?? []
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
