//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Anastasia Belyakova on 17.12.2025.
//
import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    var totalAccuracy: Double {
        let totalCorrectAnswers: Double = storage.double(forKey: Keys.totalCorrectAnswers.rawValue)
        let totalQuestionsAsked: Double = storage.double(forKey: Keys.totalQuestionsAsked.rawValue)
        if totalQuestionsAsked != 0 {
            return (totalCorrectAnswers / totalQuestionsAsked) * 100
        }
        return 0
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let bestGameCorrect = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let bestGameTotal = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let bestGameDate = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: bestGameCorrect, total: bestGameTotal, date: bestGameDate)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    func store(gameResult: GameResult) {
        let totalCorrectAnswers: Int = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        let totalQuestionsAsked: Int = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        
        storage.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue)
        storage.set(totalCorrectAnswers + gameResult.correct, forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(totalQuestionsAsked + gameResult.total, forKey: Keys.totalQuestionsAsked.rawValue)
        
        if gameResult.isBetterThan(bestGame) {
            storage.set(gameResult.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(gameResult.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(gameResult.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
}
