//
//  OptionsContainerView.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//

import UIKit

final class OptionsContainerView: UIView {
    
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layer.cornerRadius = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let toothCount = OptionsTextFieldView(text: "Enter the number of teeth")
    private let toothHeight = OptionsTextFieldView(text: "Enter the height of the tooth")
    private let toothRadius = OptionsTextFieldView(text: "Enter the tooth radius")

    var count: Int? {
        Int(toothCount.text ?? "")
    }

    var heigh: Int? {
        Int(toothHeight.text ?? "")
    }
    var radius: Int? {
        Int(toothRadius.text ?? "")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OptionsContainerView {
    func setup() {
        configureVerticaleStackView()
        configureBackgroundView()
        verticalStackView.addArrangedSubview(toothCount)
        verticalStackView.addArrangedSubview(toothHeight)
        verticalStackView.addArrangedSubview(toothRadius)
        toothCount.translatesAutoresizingMaskIntoConstraints = false
        toothRadius.translatesAutoresizingMaskIntoConstraints = false
        toothHeight.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureVerticaleStackView() {
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configureBackgroundView() {
        verticalStackView.backgroundColor = .systemBlue
    }
}

