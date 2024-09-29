//
//  OptionsViewController.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//

import UIKit

class OptionsViewController: UIViewController {
    
    private let optionsView: OptionsContainerView  = {
        let view = OptionsContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        return view
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var calculateButton: CalculateButton = {
        let button = CalculateButton(title: "Build a gear wheel")
        button.addTarget(self, action: #selector(calcualteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var keyboardBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        handleKeiboard()
    }
}

private extension OptionsViewController {
    func handleKeiboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Создаем UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // Не блокируем другие тапы (например, на кнопки)
        tapGesture.cancelsTouchesInView = false
        // Добавляем жест в view
        view.addGestureRecognizer(tapGesture)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.keyboardBottomConstraint?.constant = -(keyboardSize.height)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.keyboardBottomConstraint?.constant = self.view.safeAreaInsets.bottom - 64
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupInitialState() {
        configureBackgroundView()
        configureInforamtionView()
        configureErrorLabelView()
        configureCalculateButton()
    }
    
    func configureInforamtionView() {
        view.addSubview(optionsView)
        NSLayoutConstraint.activate([
            optionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func configureErrorLabelView() {
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: optionsView.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func configureCalculateButton() {
        view.addSubview(calculateButton)
        NSLayoutConstraint.activate([
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calculateButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        let bottomConstraint = calculateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        bottomConstraint.isActive = true
        keyboardBottomConstraint = bottomConstraint
    }

    func configureBackgroundView() {
        view.backgroundColor = .systemCyan
    }
    
    @objc func calcualteButtonPressed() {
        
        guard
            let toothCount = optionsView.count,
            let toothHeight = optionsView.heigh,
            let toothRadius = optionsView.radius
        else {
            errorLabel.text = "Enter numeric value"
            return
        }

        let viewController = GearViewController()
        viewController.configureGear(with: toothCount, height: toothHeight, radius: toothRadius)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

