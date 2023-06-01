//
//  FavouriteMovieListItem.swift
//  MyMovieApp
//
//  Created by Mehtab on 11/05/2023.
//

import SwiftUI
import CoreData

struct FavouriteMovieListItem: View {
    
    var movie: Movie
    @Binding var favoriteMovies: [Movie]
    
    var viewContext: NSManagedObjectContext = PersistenceController.shared.context
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(movie.name)
                    .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "heart.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 25, height: 22)
                    .onTapGesture {
                        removeMovie()
                    }
                
            }
            
            if let imageURL = movie.imageURL {
                            AsyncImage(url: imageURL, scale: 1.0) { image in
                                image
                                    .resizable()
                                    .cornerRadius(10.0)
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                            } placeholder: {
                                // Placeholder image or activity indicator while loading
                                ProgressView()
                            }
                        }
            
            
            Text(String(format: "Rating: %.1f", movie.rating))
                .font(.subheadline)
                .foregroundColor(.orange)
                .padding(.top, 5)
            
            Text(movie.description)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.darkGray))
                .padding(.top, 5)
        }
        .listRowSeparator(.hidden)
        
    }
    private func removeMovie() {
        if let index = favoriteMovies.firstIndex(of: movie) {
            deleteMovies(at: IndexSet(integer: index))
            favoriteMovies.remove(at: index)
        }
    }
    private func deleteMovies(at offsets: IndexSet) {
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
    
    private func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}

//struct FavouriteMovieListItem_Previews: PreviewProvider {
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
