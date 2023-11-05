//
//  FooterControlsLayersControl.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import UIKit

final class FooterControlsLayersControl: UIControl {
    // MARK: - Subviews

    private let titleLabel = {
        let label = UILabel()
        label.text = "Слои"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let shevronImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shevron_up")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                shevronImageView.image = UIImage(named: "shevron_down")
                backgroundColor = UIColor(hex: "#A8DB10")
            } else {
                shevronImageView.image = UIImage(named: "shevron_up")
                backgroundColor = .white
            }
        }
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setupComponents()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup functions

    private func setupComponents() {
        addSubview(titleLabel)
        addSubview(shevronImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.titleLabelLeadingInset),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            shevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.shevronImageViewTrailingInset),
            shevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

private enum Constant {
    static let titleLabelLeadingInset: CGFloat = 10

    static let shevronImageViewTrailingInset: CGFloat = 10
}
