//
//  MainViewModel.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 02.11.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Combine

final class MainViewModel {
    // MARK: - Props

    @Published var layersListIsHidden = true

    let instruments = [
        Instrument(title: "гитара", imageName: "guitar", samples: [Sample(title: "гитара 1")]),
        Instrument(title: "ударные", imageName: "drums", samples: [Sample(title: "ударные 1")]),
        Instrument(title: "духовые", imageName: "trumpet", samples: [Sample(title: "духовые 1")])
    ]
    let layersListViewModel = LayersListViewModel()

    // MARK: - Initialization

    init() {}

    // MARK: - Public functions

    // MARK: - Private functions

}

// MARK: - InstrumentsViewDelegate

extension MainViewModel: InstrumentsViewDelegate {
    func instrumentDidTouch(instrument: Instrument) {
        guard let sample = instrument.samples.first else { return }
        layersListViewModel.add(sample: sample)
    }
}

// MARK: - FooterControlsViewDelegate

extension MainViewModel: FooterControlsViewDelegate {
    func footerControlsLayersDidTouch(isSelected: Bool) {
        layersListIsHidden = !isSelected
    }

    func footerControlsMicrphoneDidTouch() {}

    func footerControlsRecordDidTouch() {}

    func footerControlsStopRecordingDidTouch() {}

    func footerControlsPlayDidTouch() {}

    func footerControlsPauseDidTouch() {}
}
