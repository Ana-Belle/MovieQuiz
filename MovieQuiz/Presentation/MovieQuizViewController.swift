import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter = AlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        configureUI()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    private func show(alert result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            presenter.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func show(step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        setButtonsEnabled(true)
        imageView.layer.borderWidth = 0
    }
    
    func showResults() {
        let result = presenter.makeQuizResultsViewModel()
        show(alert: result)
    }
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.didAnswer(isYes: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.didAnswer(isYes: false)
    }
    
}
