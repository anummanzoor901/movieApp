//
//  MyMovieAppApp.swift
//  MyMovieApp
//
//  Created by Mehtab on 09/05/2023.
//

import SwiftUI

@main
struct MyMovieAppApp: App {
   // @StateObject private var dislikeMovies = getDislikedMovies() // Add the disliked movies
        
    var body: some Scene {
        WindowGroup {
            FavouriteMovieList(favouriteViewModel: FavouriteViewModel())
        }
    }
}
