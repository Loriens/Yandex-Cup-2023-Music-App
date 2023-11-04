//
//  InstrumentItemView.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 04.11.2023.
//

import UIKit

final class InstrumentItemView: UIView {
    // MARK: - Subviews

    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: instrument.imageName)
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = Constant.instrumentImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = instrument.title
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    // MARK: - Props

    private let instrument: Instrument

    override var intrinsicContentSize: CGSize {
        return Constant.viewSize
    }

    // MARK: - Lifecycle

    init(instrument: Instrument) {
        self.instrument = instrument
        super.init(frame: .zero)
        setupComponents()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup functions

    private func setupComponents() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constant.instrumentImageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: Constant.instrumentImageSize.height),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.titlelabelTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private enum Constant {
    static let viewSize = CGSize(width: 80, height: 83)

    static let instrumentImageSize = CGSize(width: 60, height: 60)
    static let instrumentImageCornerRadius: CGFloat = 30

    static let titlelabelTopInset: CGFloat = 68
}
