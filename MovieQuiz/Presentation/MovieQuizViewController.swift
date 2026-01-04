import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Private properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showFirstQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(step: viewModel)
        }
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    // MARK: - Question flow
    private func showFirstQuestion() {
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
    }
    
    private func convert(_ model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func show(step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.borderWidth = 0
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(gameResult: GameResult(correct: correctAnswers, total: questionsAmount, date: Date()))
            showResults()
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    // MARK: - Results
    private func showResults() {
        let resultText = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
        let result = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: resultText,
            buttonText: "Сыграть ещё раз"
        )
        show(alert: result)
    }
    
    private func show(alert result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            
            self.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        showFirstQuestion()
    }
    
    // MARK: - Answer logic
    private func processAnswer(_ isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorrect { correctAnswers += 1 }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == true
        processAnswer(isCorrect)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == false
        processAnswer(isCorrect)
    }
    
}
