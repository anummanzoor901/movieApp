//
//  ContentView.swift
//  MyMovieApp
//
//  Created by Mehtab on 09/05/2023.
//

//  ContentView.swift
//  MyMovieApp
//
//  Created by Mehtab on 09/05/2023.
//

import SwiftUI
import CoreData

struct FavouriteMovieList: View {
    @State private var isSearchViewPresented = false
    @State private var isMovieDetailPresented = false
    @State private var searchText = ""
    @State var favoriteMovies: [Movie] // Add favoriteMovies property
    @State var dislikeMovie: [Movie]
    
 //   @Environment(\.managedObjectContext) private var viewContext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.context
   // @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .center) {
                    Text("Favourites")
                        .font(.headline)
                        .foregroundColor(.black)

                    HStack {
                        Spacer()
                        Button(action: {
                            isSearchViewPresented = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 19, height: 19)
                                .padding(.trailing, 16)
                        }
                        .sheet(isPresented: $isSearchViewPresented) {
                            SearchView(isSearchViewPresented: $isSearchViewPresented, favoriteMovies: $favoriteMovies, dislikeMovie: $dislikeMovie) // Pass favoriteMovies as a binding
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                }
                .frame(height: 40)

                List(favoriteMovies, id: \.self) { movie in // Display favoriteMovies instead of movies
                    FavouriteMovieListItem(movie: movie, favoriteMovies: $favoriteMovies) // Pass favoriteMovies as a binding
                        .onTapGesture {
                            isMovieDetailPresented = true
                        }
                        .sheet(isPresented: $isMovieDetailPresented) {
                            MovieDetailView(content: FavouriteMovieListItem(movie: movie, favoriteMovies: $favoriteMovies)) // Pass favoriteMovies as a binding
                        }
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
                    loadFavoriteMovies()
                }
    }
    private func loadFavoriteMovies() {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let fetchedMovies = try viewContext.fetch(fetchRequest)
            favoriteMovies = fetchedMovies.map { movieEntity in
                Movie(name: movieEntity.name ?? "",
                      rating: movieEntity.rating,
                      imageName: movieEntity.imageName,
                      description: movieEntity.descriptionText ?? "",
                      isFavorite: movieEntity.isFavorite,
                      isDisliked: movieEntity.isDisliked,
                      imageData: movieEntity.imageData)
            }
        } catch {
            print("Failed to fetch favorite movies: \(error)")
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavouriteMovieList(favoriteMovies: getMovies())
//    }
//}



func getMovies() -> [Movie] {
    let movies = [
        Movie(name: "The Godfather", rating: 9, imageName: "godfather", description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son. The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", isFavorite: false
              , isDisliked: false),
        Movie(name: "The Shawshank Redemption", rating: 9, imageName: "shawshank", description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", isFavorite: false, isDisliked: false),
        Movie(name: "The Dark Knight", rating: 8, imageName: "darkknight", description: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.", isFavorite: false, isDisliked: false),
        Movie(name: "Pulp Fiction", rating: 8, imageName: "pulpfiction", description: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", isFavorite: false, isDisliked: false),
        Movie(name: "The Lord of the Rings: The Return of the King", rating: 9, imageName: "lotr", description: "Gandalf and Aragorn lead the World of Men against Sauron's army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.", isFavorite: false, isDisliked: false)
    ]
    return movies
}

func getDislikedMovies() -> [Movie] {
    let movies = [
        Movie(name: "The Godfather", rating: 9, imageName: "godfather", description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son. The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", isFavorite: false
              , isDisliked: false),
        Movie(name: "The Shawshank Redemption", rating: 9, imageName: "shawshank", description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", isFavorite: false, isDisliked: false)
    ]
    
    return movies
}
