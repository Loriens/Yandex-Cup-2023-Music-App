//
//  InstrumentsView.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 02.11.2023.
//

import UIKit

final class InstrumentsView: UIView {
    // MARK: - Subviews

    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var instrumentItemViews: [UIView] = []

    // MARK: - Props

    private var instruments: [Instrument] = []

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
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Actions

    @objc
    private func instrumentDidTouch(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag, instruments.indices.contains(tag) else { return }
        let instrument = instruments[tag]
        print("instrumentButtonDidTouch instrument \(instrument)")
    }

    // MARK: - Public functions

    func setupView(instruments: [Instrument]) {
        instrumentItemViews.forEach { $0.removeFromSuperview() }
        instrumentItemViews = []

        self.instruments = instruments

        instruments.enumerated().forEach { index, instrument in
            let instrumentItemView = makeInstrumentItemView(index: index, instrument: instrument)
            stackView.addArrangedSubview(instrumentItemView)
            instrumentItemViews.append(instrumentItemView)
        }
    }

    // MARK: - Private functions

    private func makeInstrumentItemView(index: Int, instrument: Instrument) -> UIView {
        let view = InstrumentItemView(instrument: instrument)
        view.tag = index
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(instrumentDidTouch))
        view.addGestureRecognizer(gestureRecognizer)
        view.isUserInteractionEnabled = true
        return view
    }
}

private enum Constant {}
