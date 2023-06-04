//
//  SearchView.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchViewModel:SearchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchViewModel.searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: searchViewModel.searchText) { text in
                            if text.count > 3 {
                                searchViewModel.searchMovies() // Call searchMovies() when the text changes
                            }
                            
                        }
                    
                    Button(action: {
                        searchViewModel.cancelSearch()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                        
                    }
                }
                .padding()
                
                if searchViewModel.searchResults.isEmpty {
                    Spacer()
                    Text("No results found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(searchViewModel.searchResults, id: \.self) { movie in
                            
                            SearchListItem(movie: movie, disLikeAction: {
                                searchViewModel.addDislike(movie: movie)
                            }, favouriteAction: {
                                if movie.isFavorite == true {
                                    searchViewModel.removefavoriteMovie(movie: movie)
                                }
                                else {
                                    searchViewModel.addFavourite(movie: movie)
                                }
                            })
                            .onTapGesture {
                                searchViewModel.isMovieDetailPresented = true
                                
                            }
                            .sheet(isPresented: $searchViewModel.isMovieDetailPresented) {
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
                searchViewModel.searchText = ""
            }
        }
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
