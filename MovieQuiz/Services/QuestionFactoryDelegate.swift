//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anastasia Belyakova on 15.12.2025.
//

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
