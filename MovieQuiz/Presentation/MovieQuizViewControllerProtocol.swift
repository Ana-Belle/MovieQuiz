//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Anastasia Belyakova on 18.01.2026.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(step: QuizStepViewModel)
    
    func showResults()
    
    func setButtonsEnabled(_ isEnabled: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

