//
//  SoundSettingsView.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 04.11.2023.
//

import UIKit

final class SoundSettingsView: UIView {
    // MARK: - Subviews

    private lazy var backgroundView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.insertSublayer(backgroundLayer, at: 0)
        return view
    }()

    // MARK: - Props

    private let backgroundLayer = {
        let layer = CAGradientLayer()
        let color = UIColor(hex: "#5A50E2")!
        layer.colors = [
            UIColor.clear.cgColor,
            color.withAlphaComponent(0.3).cgColor,
            color.withAlphaComponent(0.5).cgColor,
            color.withAlphaComponent(1.0).cgColor
        ]
        layer.locations = [0.0, 0.3, 0.5, 1.0]
        return layer
    }()

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setupComponents()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        backgroundLayer.frame = bounds
    }

    // MARK: - Setup functions

    private func setupComponents() {
        addSubview(backgroundView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Actions

    // MARK: - Public functions

    // MARK: - Private functions
}

private enum Constant {}
