//
//  GearViewController.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//

import UIKit

class GearViewController: UIViewController {
    
    private let gearView: GearView = {
        let view = GearView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
    
    func configureGear(with toothCount: Int, height: CGFloat, radius: CGFloat) {
        gearView.toothCount = toothCount
        gearView.toothHeight =  height
        gearView.toothRadius = radius
        gearView.setNeedsDisplay()
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
            gearView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            gearView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            gearView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            gearView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}

