//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anastasia Belyakova on 15.12.2025.
//

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
