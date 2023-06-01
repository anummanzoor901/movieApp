//
//  MovieModel.swift
//  MyMovieApp
//
//  Created by Mehtab on 17/05/2023.
//

import Foundation

struct Movie: Hashable, Codable {
    let name: String
    let rating: Double
    let imageName: String?
    let description: String
    var isFavorite: Bool?
    var isDisliked: Bool?
    var imageData: Data? // Add imageData property

    private enum CodingKeys: String, CodingKey {
        case name = "original_title"
        case rating = "vote_average"
        case imageName = "poster_path"
        case description = "overview"
        case isFavorite
        case isDisliked
        
    }
    
    var imageURL: URL? {
        guard let imgURL = imageName else {
            return nil
        }
            return URL(string: "https://image.tmdb.org/t/p/w500/\(imgURL)")
    }
}
