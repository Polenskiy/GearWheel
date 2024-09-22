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
    
    private let calculateButton: CalculateButton = {
        let button = CalculateButton(title: "Build a gear wheel")
        button.addTarget(self, action: #selector(calcualteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
}

private extension OptionsViewController {
    
    func setupInitialState() {
        configureBackgroundView()
        configureInforamtionView()
        configureView()
        configureCalculateButton()
    }
    
    func configureInforamtionView() {
        view.addSubview(optionsView)
        NSLayoutConstraint.activate([
            optionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            optionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -500),
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func configureCalculateButton() {
        view.addSubview(calculateButton)
        NSLayoutConstraint.activate([
            calculateButton.topAnchor.constraint(equalTo: optionsView.bottomAnchor, constant: 30),
            calculateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    func configureView() {
        optionsView.backgroundColor = .systemCyan
    }
    
    func configureBackgroundView() {
        view.backgroundColor = .systemCyan
    }
    
    @objc func calcualteButtonPressed() {
        
        guard
            let toothCountText = optionsView.toothCount.informationTextField.text,
            let toothCount = Int(toothCountText),
            let toothHeightText = optionsView.toothHeight.informationTextField.text,
            let toothHeightValue = Double(toothHeightText),
            let toothRadiusText = optionsView.toothRadius.informationTextField.text,
            let toothRadiusValue = Double(toothRadiusText)
        else {
            return
        }
        
        let toothHeight = CGFloat(toothHeightValue)
        let toothRadius = CGFloat(toothRadiusValue)
        
        let viewController = GearViewController()
        
        viewController.configureGear(with: toothCount, height: toothHeight, radius: toothRadius)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

