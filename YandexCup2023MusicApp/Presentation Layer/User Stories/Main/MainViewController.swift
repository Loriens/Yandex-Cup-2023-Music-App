//
//  MainViewController.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 02.11.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    // MARK: - Subviews

    private let instrumentsView = {
        let view = InstrumentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let soundSettingsView = {
        let view = SoundSettingsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let footerControlsView = {
        let view = FooterControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Props

    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupComponents()
        setupConstraints()
        setupViewModel()

        viewModel.loadData()
    }
    
    // MARK: - Setup functions

    private func setupComponents() {
        view.addSubview(instrumentsView)
        view.addSubview(soundSettingsView)
        view.addSubview(footerControlsView)
    }

    private func setupConstraints() { 
        NSLayoutConstraint.activate([
            instrumentsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.verticalInset),
            instrumentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalInset),
            instrumentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalInset),
            instrumentsView.heightAnchor.constraint(equalToConstant: Constant.instrumentsViewHeight),

            soundSettingsView.topAnchor.constraint(equalTo: instrumentsView.bottomAnchor, constant: Constant.soundSettingsViewTopInset),
            soundSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalInset),
            soundSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalInset),
            soundSettingsView.bottomAnchor.constraint(equalTo: footerControlsView.topAnchor, constant: -Constant.verticalInset),

            footerControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.horizontalInset),
            footerControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.horizontalInset),
            footerControlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constant.verticalInset),
            footerControlsView.heightAnchor.constraint(equalToConstant: Constant.footerControlsViewHeight),
        ])
    }

    private func setupViewModel() {
        [
            viewModel.$instruments.sink { [unowned self] instruments in
                guard !instruments.isEmpty else { return }
                instrumentsView.setupView(instruments: instruments)
            },
            viewModel.$layersIsHidden.sink { [unowned self] isHidden in
                print("hide layer view")
            }
        ].forEach { $0.store(in: &cancellables) }
    }

    // MARK: - Actions

    // MARK: - Private functions

}

private enum Constant {
    static let verticalInset: CGFloat = 15
    static let horizontalInset: CGFloat = 15

    static let instrumentsViewHeight: CGFloat = 83

    static let soundSettingsViewTopInset: CGFloat = 38

    static let footerControlsViewHeight: CGFloat = 34
}
