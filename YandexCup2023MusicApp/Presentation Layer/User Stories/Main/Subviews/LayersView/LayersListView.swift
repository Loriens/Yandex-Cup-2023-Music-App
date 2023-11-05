//
//  LayersListView.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import Combine
import UIKit

final class LayersListView: UIView {
    // MARK: - Subviews

    private let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Props

    private var viewModel: LayersListViewModel?
    private var models: [LayersListCellModel] = []
    private var cancellables = Set<AnyCancellable>()

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
        addSubview(tableView)

        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(LayersListCell.self)
        tableView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi));
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Actions

    // MARK: - Public functions

    func setup(viewModel: LayersListViewModel) {
        cancellables.removeAll()

        self.viewModel = viewModel

        [
            viewModel.$models.sink { [unowned self] models in
                self.models = models
                tableView.reloadData()
            }
        ].forEach { $0.store(in: &cancellables) }
    }

    // MARK: - Private functions
}

private enum Constant {
    static let cellHeight: CGFloat = 46
}

// MARK: - UITableViewDataSource

extension LayersListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LayersListCell.self, for: indexPath)
        cell.setup(model: models[indexPath.item])
        cell.delegate = viewModel
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LayersListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellHeight
    }
}
