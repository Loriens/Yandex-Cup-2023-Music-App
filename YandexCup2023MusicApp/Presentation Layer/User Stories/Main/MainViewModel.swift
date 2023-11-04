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

    @Published var instruments: [Instrument] = []
    @Published var layersIsHidden = false

    // MARK: - Initialization
    init() {}

    // MARK: - Public functions

    func loadData() {
        instruments = [
            Instrument(title: "гитара", imageName: "guitar", samples: []),
            Instrument(title: "ударные", imageName: "drums", samples: []),
            Instrument(title: "духовые", imageName: "trumpet", samples: [])
        ]
    }

    // MARK: - Private functions

}

// MARK: - FooterControlsViewDelegate

extension MainViewModel: FooterControlsViewDelegate {
    func footerControlsLayersDidTouch(isSelected: Bool) {
        layersIsHidden = isSelected
    }

    func footerControlsMicrphoneDidTouch() {}

    func footerControlsRecordDidTouch() {}

    func footerControlsPlayDidTouch() {}

    func footerControlsPauseDidTouch() {}
}
