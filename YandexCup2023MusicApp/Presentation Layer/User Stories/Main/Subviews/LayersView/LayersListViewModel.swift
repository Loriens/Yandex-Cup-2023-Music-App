//
//  LayersListViewModel.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import Foundation
import Combine

final class LayersListViewModel {
    // MARK: - Props

    @Published var models: [LayersListCellModel] = []

    // MARK: - Initialization

    init() {}

    // MARK: - Public functions

    func add(sample: Sample) {
        let model = LayersListCellModel(id: UUID(), sample: sample)
        models.append(model)
    }

    // MARK: - Private functions

}

// MARK: - LayersListCellDelegate

extension LayersListViewModel: LayersListCellDelegate {
    func layersListLayerPlayDidTouch(model: LayersListCellModel) {}
    
    func layersListLayerPauseDidTouch(model: LayersListCellModel) {}
    
    func layersListLayerVolumeDidTouch(model: LayersListCellModel) {}
    
    func layersListLayerMutedVolumeDidTouch(model: LayersListCellModel) {}
    
    func layersListLayerDeleteDidTouch(model: LayersListCellModel) {
        models.removeAll(where: { $0.id == model.id })
    }
}
