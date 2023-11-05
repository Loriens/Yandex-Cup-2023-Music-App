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
    func footerControlsStopRecordingDidTouch()
    func footerControlsPlayDidTouch()
    func footerControlsPauseDidTouch()
}

final class FooterControlsView: UIView {
    // MARK: - Subviews

    private let layersControl = {
        let control = FooterControlsLayersControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private let recordControlsStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.recordControlsStackViewSpacing
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
        button.setImage(UIImage(named: "stop_recording"), for: .selected)
        return button
    }()
    private let playAndPauseButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.setImage(UIImage(named: "pause"), for: .selected)
        return button
    }()

    // MARK: - Props

    weak var delegate: FooterControlsViewDelegate?

    private lazy var recordControls = [
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
        addSubview(layersControl)
        addSubview(recordControlsStackView)
        setupRightControls()
    }

    private func setupRightControls() {
        ([layersControl] + recordControls).forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonDidTouch), for: .touchUpInside)
            button.layer.cornerRadius = Constant.recordControlCornerRadius
            button.layer.masksToBounds = true
            button.backgroundColor = .white
        }

        recordControls.forEach { recordControlsStackView.addArrangedSubview($0) }
    }

    private func setupConstraints() {
        let recordControlsStackViewWidth = Constant.recordControlSize.width * CGFloat(recordControls.count)
            + CGFloat(recordControls.count - 1) * Constant.recordControlsStackViewSpacing

        var constraints = [
            layersControl.topAnchor.constraint(equalTo: topAnchor),
            layersControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            layersControl.widthAnchor.constraint(equalToConstant: Constant.layerButtonSize.width),
            layersControl.heightAnchor.constraint(equalToConstant: Constant.layerButtonSize.height),

            recordControlsStackView.topAnchor.constraint(equalTo: topAnchor),
            recordControlsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recordControlsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recordControlsStackView.widthAnchor.constraint(equalToConstant: recordControlsStackViewWidth)
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
    private func buttonDidTouch(sender: UIControl) {
        switch sender {
        case layersControl:
            delegate?.footerControlsLayersDidTouch(isSelected: !layersControl.isSelected)
        case microphoneButton:
            delegate?.footerControlsMicrphoneDidTouch()
        case recordButton:
            recordButton.isSelected.toggle()
            recordButton.isSelected ? delegate?.footerControlsRecordDidTouch() : delegate?.footerControlsStopRecordingDidTouch()
        case playAndPauseButton:
            playAndPauseButton.isSelected ? delegate?.footerControlsPauseDidTouch() : delegate?.footerControlsPlayDidTouch()
        default:
            break
        }
    }

    // MARK: - Public functions

    func setup(viewModel: FooterControlsViewModel) {
        layersControl.isSelected = viewModel.layersControlIsSelected
        playAndPauseButton.isSelected = viewModel.playAndPauseIsSelected
    }
}

private enum Constant {
    static let layerButtonSize = CGSize(width: 74, height: 34)

    static let recordControlsStackViewSpacing: CGFloat = 5
    static let recordControlSize = CGSize(width: 34, height: 34)
    static let recordControlCornerRadius: CGFloat = 4
}
