import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Private properties
    private let questions = QuizQuestion.mock
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showFirstQuestion()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    // MARK: - Question flow
    private func showFirstQuestion() {
        let model = questions[currentQuestionIndex]
        let vm = convert(model)
        show(step: vm)
    }
    
    private func convert(_ model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
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
    
    private func showNextOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            let vm = convert(questions[currentQuestionIndex])
            show(step: vm)
        }
    }
    
    // MARK: - Results
    private func showResults() {
        let vm = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: "Ваш результат: \(correctAnswers)/\(questions.count)",
            buttonText: "Сыграть ещё раз"
        )
        show(alert: vm)
    }
    
    private func show(alert vm: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: vm.title,
            message: vm.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: vm.buttonText, style: .default) { _ in
            self.restartGame()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextOrResults()
        }
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == true
        processAnswer(isCorrect)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == false
        processAnswer(isCorrect)
    }
    
}
