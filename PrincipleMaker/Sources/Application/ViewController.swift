import UIKit


class ViewController: UIViewController {
    
    private let textView = UITextView()
    private let submitButton = UIButton(type: .system)
    
    private let eventExtractor = EventExtractor()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        eventExtractor.initializeModel()
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        attribute()
        layout()
    }
    
    private func attribute() {
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.text = "Enter your text here..."
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(textView)
        view.addSubview(submitButton)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textView.heightAnchor.constraint(equalToConstant: 150),
            
            submitButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapSubmit() {
        let text = textView.text ?? ""
        
        if eventExtractor.isModelAvailable() {
            Task { [weak self] in
                guard let self else { return }
                do {
                    let events = try await eventExtractor.extractEvent(from: text)
                    print(events)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("모델을 사용할 수 없음")
        }
    }
}
