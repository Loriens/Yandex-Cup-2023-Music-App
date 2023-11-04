//
//  FooterControlsView.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 04.11.2023.
//

import UIKit

protocol FooterControlsViewDelegate: AnyObject {
    func footerControlsLayersDidTouch(isSelected: Bool)
    func footerControlsMicrphoneDidTouch()
    func footerControlsRecordDidTouch()
    func footerControlsPlayDidTouch()
    func footerControlsPauseDidTouch()
}

final class FooterControlsView: UIView {
    // MARK: - Subviews

    private let layersButton = {
        let button = UIButton()
        button.setTitle("Слои", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    private let recordControlsStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.recordControlsStackViewSpacig
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let microphoneButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "microphone"), for: .normal)
        return button
    }()
    private let recordButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "record"), for: .normal)
        return button
    }()
    private let playAndPauseButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        return button
    }()

    // MARK: - Props

    weak var delegate: FooterControlsViewDelegate?

    private lazy var recordControls = [
        microphoneButton,
        recordButton,
        playAndPauseButton
    ]

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
        addSubview(layersButton)
        addSubview(recordControlsStackView)
        setupRightControls()
    }

    private func setupRightControls() {
        ([layersButton] + recordControls).forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonDidTouch), for: .touchUpInside)
            button.layer.cornerRadius = Constant.recordControlCornerRadius
            button.layer.masksToBounds = true
            button.backgroundColor = .white
        }

        recordControls.forEach { recordControlsStackView.addArrangedSubview($0) }
    }

    private func setupConstraints() {
        var constraints = [
            layersButton.topAnchor.constraint(equalTo: topAnchor),
            layersButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            layersButton.widthAnchor.constraint(equalToConstant: Constant.layerButtonSize.width),
            layersButton.heightAnchor.constraint(equalToConstant: Constant.layerButtonSize.height),

            recordControlsStackView.topAnchor.constraint(equalTo: topAnchor),
            recordControlsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recordControlsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recordControlsStackView.widthAnchor.constraint(equalToConstant: Constant.recordControlsStackViewWidth)
        ]

        recordControls.forEach { button in
            constraints.append(contentsOf: [
                button.widthAnchor.constraint(equalToConstant: Constant.recordControlSize.width),
                button.heightAnchor.constraint(equalToConstant: Constant.recordControlSize.height),
            ])
        }

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Actions

    @objc
    private func buttonDidTouch(sender: UIButton) {
        switch sender {
        case layersButton:
            layersButton.isSelected.toggle()
            layersButton.backgroundColor = layersButton.isSelected ? UIColor(hex: "#A8DB10") : .white
            delegate?.footerControlsLayersDidTouch(isSelected: layersButton.isSelected)
        case microphoneButton:
            delegate?.footerControlsMicrphoneDidTouch()
        case recordButton:
            print("buttonDidTouch recordButton")
        case playAndPauseButton:
            print("buttonDidTouch playAndPauseButton")
        default:
            break
        }
    }

    // MARK: - Public functions

    // MARK: - Private functions
}

private enum Constant {
    static let layerButtonSize = CGSize(width: 74, height: 34)

    static let recordControlsStackViewSpacig: CGFloat = 5
    static let recordControlsStackViewWidth: CGFloat = 112
    static let recordControlSize = CGSize(width: 34, height: 34)
    static let recordControlCornerRadius: CGFloat = 4
}
