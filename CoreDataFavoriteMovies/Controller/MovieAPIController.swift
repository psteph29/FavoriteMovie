//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieAPIController {
    
enum fetchMoviesError: Error, LocalizedError {
    case movieNotFound
}
    
let baseURL = URL(string: "http://www.omdbapi.com/")!
let apiKey = "6b69c988"

func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
    var searchURL = baseURL
    let apiKeyItem = URLQueryItem(name: "apiKey", value: apiKey)
    let searchItem = URLQueryItem(name: "s", value: searchTerm)

    searchURL.append(queryItems: [searchItem, apiKeyItem])

            let (data, response) = try await URLSession.shared.data(from: searchURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw fetchMoviesError.movieNotFound
            }
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(SearchResponse.self, from: data)
            return searchResponse.movies
}
}

