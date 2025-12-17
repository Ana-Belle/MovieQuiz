//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Anastasia Belyakova on 17.12.2025.
//

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    
    func store(gameResult: GameResult)
}
