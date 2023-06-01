//
//  MovieEntity+CoreDataProperties.swift
//  MyMovieApp
//
//  Created by Mehtab on 18/05/2023.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var imageName: String?

}

extension MovieEntity : Identifiable {

}
