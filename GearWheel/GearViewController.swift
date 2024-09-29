//
//  GearViewController.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//

import UIKit

class GearViewController: UIViewController {
    private lazy var gearView: GearView = {
        let view = GearView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        configureErrorLabelView()
    }
    
    func configureGear(with toothCount: Int, height: Int, radius: Int) {
        gearView.configure(toothCount: toothCount, height: height, radius: radius)
    }
}

extension GearViewController: GearViewDelegate {
    func handle(error: GeometryError) {
        switch error {
        case .height(from: let from, to: let to):
            errorLabel.text = "Высота должна быть больше: \(from) и меньше: \(to)"
        case .radius(less: let value):
            errorLabel.text = "Радиус должен быть меньше \(value)"
        }
    }
}

private extension GearViewController {
    
    func setupInitialState() {
        configureBackgroundView()
        configureGearView()
    }
    
    func configureBackgroundView() {
        view.backgroundColor = .systemCyan
    }

    func configureGearView() {
        view.addSubview(gearView)
        gearView.backgroundColor = .systemCyan
        NSLayoutConstraint.activate([
            gearView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            gearView.heightAnchor.constraint(equalTo: view.widthAnchor),
            gearView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gearView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func configureErrorLabelView() {
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
