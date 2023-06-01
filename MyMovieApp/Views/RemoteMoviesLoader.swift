//
//  RemoteMoviesLoader.swift
//  MyMovieApp
//
//  Created by Mehtab on 31/05/2023.
//

import Foundation

class RemoteMoviesLoader {
    
    let url = "https://api.themoviedb.org/3/search/movie?api_key=08d9aa3c631fbf207d23d4be591ccfc3&page=1&include_adult=false&query="
    
    func loadMovies(from query:String, completion:@escaping([Movie]) -> Void){
        let urlWithQuery = URL(string: url+query)!
        URLSession.shared.dataTask(with: urlWithQuery) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print(error)
            }
        }.resume()
    }
}
