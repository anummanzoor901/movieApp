//
//  MovieStore.swift
//  MyMovieApp
//
//  Created by Mehtab on 31/05/2023.
//

import Foundation
import CoreData

class MovieStore {
    
    var viewContext: NSManagedObjectContext = PersistenceController.shared.context
    
    func saveFavourite(movie:Movie) {
        let movieEntity = MovieEntity(context: viewContext)
        movieEntity.name = movie.name
        movieEntity.rating = movie.rating
        movieEntity.imageName = movie.imageName
        movieEntity.descriptionText = movie.description
        movieEntity.imageData = movie.imageData
        saveChanges()
    }
    
    func saveDisliked(movie:Movie) {
        let movieEntity = DislikeEntity(context: viewContext)
        movieEntity.name = movie.name
        movieEntity.rating = movie.rating
        movieEntity.imageName = movie.imageName
        movieEntity.descriptionText = movie.description
        movieEntity.imageData = movie.imageData
        saveChanges()
    }
    
    
    func fetchFavourite(by name:String) -> MovieEntity? {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let fetchedMovies = try viewContext.fetch(fetchRequest)
            return fetchedMovies.first
        } catch {
            print("Failed to fetch movie entity: \(error)")
        }
        
        return nil
    }
    
    
    func fetchDisliked() -> [Movie]? {
        let fetchRequest: NSFetchRequest<DislikeEntity> = DislikeEntity.fetchRequest()
        
        do {
            let fetchedMovies:[DislikeEntity] = try viewContext.fetch(fetchRequest)
            let dislikeMovies = fetchedMovies.map { dislikeEntity in
                Movie(name: dislikeEntity.name ?? "",
                      rating: dislikeEntity.rating,
                      imageName: dislikeEntity.imageName,
                      description: dislikeEntity.descriptionText ?? "",
                      isFavorite: false,
                      isDisliked: true,
                      imageData: dislikeEntity.imageData)
            }
            return dislikeMovies
        } catch {
            print("Failed to fetch disliked movies: \(error)")
            return nil
        }
    }
    
    
    func delete(movie:Movie) {
        if let movieEntity = fetchFavourite(by: movie.name) {
            viewContext.delete(movieEntity)
        }
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
