//
//  DislikeEntity+CoreDataProperties.swift
//  MyMovieApp
//
//  Created by Mehtab on 23/05/2023.
//
//

import Foundation
import CoreData


extension DislikeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DislikeEntity> {
        return NSFetchRequest<DislikeEntity>(entityName: "DislikeEntity")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double

}

extension DislikeEntity : Identifiable {

}
