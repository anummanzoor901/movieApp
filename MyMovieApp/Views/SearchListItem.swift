//
//  ListView.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI
import Kingfisher
import CoreData

struct SearchListItem: View {
    @Binding var movie: Movie
    
    @Binding var movies: [Movie]
    @Binding var favoriteMovies: [Movie] // Add favoriteMovies as a binding
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var dislikeMovie: [Movie]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(movie.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: movie.isFavorite ?? false ? "heart.fill" : "heart")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 22, height: 19)
                    .onTapGesture {
                        if movie.isFavorite == true {
                            removefavoriteMovie()
                        }
                        else {
                            addFavourite()
                        }
                    }
            }
            KFImage(movie.imageURL)
                .placeholder{ProgressView()}
                .resizable()
                .background(Color.gray)
                .cornerRadius(10.0)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
            
            
            
            HStack {
                Text(String(format: "Rating: %.1f", movie.rating))
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
                
                if !(movie.isFavorite ?? false) {
                    Text("Don't want to see again")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .onTapGesture {
                            // TO-DO
                            movie.isDisliked?.toggle()
                            addDislike()
                            removedislikedMovie()
                        }
                }
                
                
            }
            .padding(.top, 5)
            
            Text(movie.description)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.darkGray))
                .padding(.top, 5)
        }
        .listRowSeparator(.hidden)
        
    }
    
    private func removedislikedMovie() {
        if let index = movies.firstIndex(of: movie) {
            movies.remove(at: index)
        }
    }
    
  
    private func removefavoriteMovie() {
        if let index = favoriteMovies.firstIndex(of: movie) {
            deleteMovies()
            movie.isFavorite = false
            favoriteMovies.remove(at: index)
        }
    }
    
    func addFavourite() {
        saveFavouriteMovie(for: movie)
        movie.isFavorite = true
        favoriteMovies.append(movie)
    }
    private func toggleFavorite(for movie: Movie) {
        print("toggle is working")
        if favoriteMovies.contains(movie) {
            favoriteMovies.removeAll { $0.name == movie.name }
        } else {
            favoriteMovies.append(movie)
        }
        
        saveFavouriteMovie(for: movie)
    }
    
    private func deleteMovies() {
        if let movieEntity = fetchMovieEntity(for: movie) {
            viewContext.delete(movieEntity)
        }
        saveChanges()
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
    private func saveFavouriteMovie(for movie: Movie) {
        print("Save changes called for movie:", movie.name)
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", movie.name)
        
        do {
                let fetchedMovies = try viewContext.fetch(fetchRequest)
                if let movieEntity = fetchedMovies.first {
                    print("Updating isFavorite property for movie:", movie.name)
                    movieEntity.isFavorite = favoriteMovies.contains(movie)
                    print("isFavorite property updated:", movieEntity.isFavorite)
                } else {
                    
                let newMovieEntity = MovieEntity(context: viewContext)
                newMovieEntity.name = movie.name
                newMovieEntity.rating = movie.rating
                newMovieEntity.imageName = movie.imageName
                newMovieEntity.descriptionText = movie.description
                newMovieEntity.isFavorite = favoriteMovies.contains(movie)
                newMovieEntity.isDisliked = movie.isDisliked ?? false
                newMovieEntity.imageData = movie.imageData
            }
            
            saveChanges()
        } catch {
            print("Failed to fetch movie entity: \(error)")
        }
    }
    
    // ==========================================
// to add a disliked movie in core data

    func addDislike() {
        saveDisliked(movie: movie)
        dislikeMovie.append(movie)
        // Remove the disliked movie from the search results
        if let index = movies.firstIndex(of: movie) {
            movies.remove(at: index)
        }
    }

    
    private func saveDisliked(movie: Movie) {
            let newDislikedEntity = DislikeEntity(context: viewContext)
            newDislikedEntity.name = movie.name
            newDislikedEntity.rating = movie.rating
            newDislikedEntity.imageName = movie.imageName
            newDislikedEntity.descriptionText = movie.description
            newDislikedEntity.isFavorite = movie.isFavorite ?? false
            newDislikedEntity.isDisliked = dislikeMovie.contains(movie)
            newDislikedEntity.imageData = movie.imageData
            saveChanges()
    }


    private func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}


//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let movies: [Movie] = getMovies()
//        let favoriteMovies = Binding<[Movie]>(
//            get: { movies.filter { $0.isFavorite ?? false } },
//            set: { _ in }
//        )
//
//        return SearchListItem(movie: .constant(movies[0]), movies: .constant(movies), favoriteMovies: favoriteMovies)
//            .padding()
//            .previewDisplayName("Default preview 2")
//    }
//}
