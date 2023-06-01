//
//  SearchView.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    
    @Binding var isSearchViewPresented: Bool
    @Binding var favoriteMovies: [Movie] // Add favoriteMovies as a binding
    @State private var isMovieDetailPresented = false
    @State private var searchResults: [Movie] = []
    @Binding var dislikeMovie: [Movie]
    @State private var searchText = ""
    
    let remoteMoviesLoader = RemoteMoviesLoader()
    
    @Environment(\.managedObjectContext) private var viewContext
    
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
                        ForEach($searchResults, id: \.self) { movie in
                            
                            SearchListItem(movie: movie, movies: $searchResults, favoriteMovies: $favoriteMovies, dislikeMovie: $dislikeMovie)
                                .onTapGesture {
                                    isMovieDetailPresented = true
                                    
                                }
                                .sheet(isPresented: $isMovieDetailPresented) {
                                    MovieDetailView(content: SearchListItem(movie: movie, movies: $searchResults, favoriteMovies: $favoriteMovies, dislikeMovie: $dislikeMovie))
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
    
    private func searchMovies() {
        
        remoteMoviesLoader.loadMovies(from: searchText, completion: { movies in
            var filteredResults = movies
            
            // Filter out disliked movies
            filteredResults = filteredResults.filter { movie in
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
    
    private func fetchMovieEntity(for movie: Movie) -> MovieEntity? {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", movie.name)
        
        do {
            let fetchedMovies = try viewContext.fetch(fetchRequest)
            return fetchedMovies.first
        } catch {
            print("Failed to fetch movie entity: \(error)")
        }
        
        return nil
    }
    private func loadDislikedMovies() {
        let fetchRequest: NSFetchRequest<DislikeEntity> = DislikeEntity.fetchRequest()
        
        do {
            let fetchedMovies:[DislikeEntity] = try viewContext.fetch(fetchRequest)
            dislikeMovie = fetchedMovies.map { dislikeEntity in
                Movie(name: dislikeEntity.name ?? "",
                      rating: dislikeEntity.rating,
                      imageName: dislikeEntity.imageName,
                      description: dislikeEntity.descriptionText ?? "",
                      isFavorite: dislikeEntity.isFavorite,
                      isDisliked: dislikeEntity.isDisliked,
                      imageData: dislikeEntity.imageData)
            }
        } catch {
            print("Failed to fetch disliked movies: \(error)")
        }
    }

}

struct MovieResponse: Codable {
    let results: [Movie]
}

