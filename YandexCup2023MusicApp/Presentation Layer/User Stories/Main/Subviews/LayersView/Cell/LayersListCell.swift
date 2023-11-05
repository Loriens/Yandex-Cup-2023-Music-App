//
//  LayersListCell.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import UIKit

protocol LayersListCellDelegate: AnyObject {
    func layersListLayerPlayDidTouch(model: LayersListCellModel)
    func layersListLayerPauseDidTouch(model: LayersListCellModel)
    func layersListLayerVolumeDidTouch(model: LayersListCellModel)
    func layersListLayerMutedVolumeDidTouch(model: LayersListCellModel)
    func layersListLayerDeleteDidTouch(model: LayersListCellModel)
}

final class LayersListCell: UITableViewCell, Reusable {
    // MARK: - Subviews

    private let contentBackgroundView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constant.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    private let titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let controlsStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = Constant.controlsStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let playAndPauseButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.setImage(UIImage(named: "pause"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let volumeButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "volume"), for: .normal)
        button.setImage(UIImage(named: "muted_volume"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.layer.cornerRadius = Constant.cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(hex: "#E4E4E4")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Props

    weak var delegate: LayersListCellDelegate?
    private var model: LayersListCellModel?

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: - Setup functions

    private func setupView() {
        contentView.addSubview(contentBackgroundView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(controlsStackView)

        [playAndPauseButton, volumeButton, deleteButton].forEach { controlsStackView.addArrangedSubview($0) }

        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .clear
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.contentBackgroundViewBottomInset),
            contentBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.titleLabelHorizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: controlsStackView.leadingAnchor, constant: -Constant.titleLabelHorizontalInset),
            titleLabel.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor),

            controlsStackView.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor),
            controlsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            controlsStackView.heightAnchor.constraint(equalToConstant: Constant.controlsStackViewHeight),

            playAndPauseButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth),
            volumeButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth),
            deleteButton.widthAnchor.constraint(equalToConstant: Constant.deleteButtonWidth),
        ])
    }

    private func setupActions() {
        [playAndPauseButton, volumeButton, deleteButton].forEach {
            $0.addTarget(self, action: #selector(buttonDidTouch), for: .touchUpInside)
        }
    }

    // MARK: - Actions

    @objc
    private func buttonDidTouch(sender: UIButton) {
        guard let model else { return }
        switch sender {
        case playAndPauseButton:
            playAndPauseButton.isSelected ? delegate?.layersListLayerPauseDidTouch(model: model) : delegate?.layersListLayerPlayDidTouch(model: model)
        case volumeButton:
            volumeButton.isSelected ? delegate?.layersListLayerMutedVolumeDidTouch(model: model) : delegate?.layersListLayerVolumeDidTouch(model: model)
        case deleteButton:
            delegate?.layersListLayerDeleteDidTouch(model: model)
        default:
            break
        }
    }

    // MARK: - Public functions

    func setup(model: LayersListCellModel) {
        self.model = model
        titleLabel.text = model.sample.title
        contentBackgroundView.backgroundColor = model.isPlaying ? UIColor(hex: "#A8DB10") : .white
        playAndPauseButton.isSelected = model.isPlaying
        volumeButton.isSelected = model.isMuted
    }

    // MARK: - Private functions
}

private enum Constant {
    static let cornerRadius: CGFloat = 4

    static let contentBackgroundViewBottomInset: CGFloat = 7

    static let titleLabelHorizontalInset: CGFloat = 10

    static let controlsStackViewSpacing: CGFloat = 5
    static let controlsStackViewHeight: CGFloat = 39
    static let controlsStackViewWidth: CGFloat = 99

    static let buttonWidth: CGFloat = 25
    static let deleteButtonWidth: CGFloat = 39
}
