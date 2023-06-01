//
/*
 ||||||*** IMPROVEMENTS ***||||||
 1 - Remove favourite action logic from favourite Item
 2 - Remove dislikeMovie array from FavouriteMovieList because it's of no use in this view
 3 - Remove passing viewContext as environment variable from FavouriteMovieList to SearchView '.environment(\.managedObjectContext, viewContext)'
 4 - Remove Environment ViewContext from SearchView
 5 - Fix preview for FavouriteListItem
 */




import SwiftUI

struct FavouriteMovieList: View {

   @ObservedObject var favouriteViewModel = FavouriteViewModel()
    
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
                            favouriteViewModel.isSearchViewPresented = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 19, height: 19)
                                .padding(.trailing, 16)
                        }
                        .sheet(isPresented: $favouriteViewModel.isSearchViewPresented) {
                            SearchView(isSearchViewPresented: $favouriteViewModel.isSearchViewPresented, favoriteMovies: $favouriteViewModel.favoriteMovies)
                        }
                    }
                }
                .frame(height: 40)
                
                List(favouriteViewModel.favoriteMovies, id: \.self) { movie in // Display favoriteMovies instead of movies
                    FavouriteMovieListItem(movie: movie, favouriteAction: {
                        favouriteViewModel.removeFavourite(movie: movie)
                    }) // Pass favoriteMovies as a binding
                    .onTapGesture {
                        favouriteViewModel.isMovieDetailPresented = true
                    }
                    .sheet(isPresented: $favouriteViewModel.isMovieDetailPresented) {
                        MovieDetailView(content: FavouriteMovieListItem(movie: movie)) // Pass favoriteMovies as a binding
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            favouriteViewModel.fetchFavouriteMovies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteMovieList()
    }
}



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
