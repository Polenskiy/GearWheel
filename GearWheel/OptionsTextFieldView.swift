//
//  OptionsTextFieldView.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//

import UIKit

final class OptionsTextFieldView: UIView {
    
    private let informationTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.textColor = .black
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var text: String? {
        informationTextField.text
    }

    init(text: String) {
        super.init(frame: .zero)
        informationTextField.placeholder = text
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OptionsTextFieldView {
    
    func setup() {
        configureInformationTextField()
    }
    
    func configureInformationTextField() {
        addSubview(informationTextField)
        NSLayoutConstraint.activate([
            informationTextField.topAnchor.constraint(equalTo: topAnchor),
            informationTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            informationTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            informationTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            informationTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
