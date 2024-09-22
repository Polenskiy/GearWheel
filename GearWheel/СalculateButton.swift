//
//  СalculateButton.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//

import UIKit

final class CalculateButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setup(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalculateButton {
    
    func setup(with title: String) {
        setTitle(title, for: .normal)
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
    }
}
