//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Anastasia Belyakova on 13.12.2025.
//
import Foundation
import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private var movies: [MostPopularMovie] = []
    
    private let moviesLoader: MoviesLoading
    private var delegate: QuestionFactoryDelegate?
    private var alertPresenter = AlertPresenter()
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.delegate?.didFailToLoadData(message: "Ошибка загрузки изображения")
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 8?"
            let correctAnswer = rating > 8
            
            let question = QuizQuestion(imageData: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
}
