//
//  MovieController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieController {
    static let shared = MovieController()
    
    private let apiController = MovieAPIController()
    private var viewContext = PersistenceController.shared.viewContext
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        return try await apiController.fetchMovies(with: searchTerm)
    }
    
    func favoriteMovie(_ movie: APIMovie) {
        let newMovie = Movie(context: viewContext)
        newMovie.title = movie.title
        newMovie.year = movie.year
        newMovie.imdbID = movie.imdbID
        newMovie.posterURLString = movie.posterURL?.absoluteString
        
        PersistenceController.shared.saveContext()
    }
    
    //    ^^^ This function takes in an APIMovie and creates a core data Movie ^^^
    
    func unFavoriteMovie(_ movie: Movie) {
        viewContext.delete(movie)
        PersistenceController.shared.saveContext()
    }
    
    func favoriteMovie(from movie: APIMovie) -> Movie? {
        let fetchRequest = Movie.fetchRequest()
        let predicate = NSPredicate(format: "imdbID == %@", movie.id)
        fetchRequest.predicate = predicate
        return try? viewContext.fetch(fetchRequest).first
    }
    
}

