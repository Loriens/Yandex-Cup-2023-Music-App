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

    private let audioSampleService: AudioSampleService
    private var userInteractionDidHappen = false

    // MARK: - Initialization

    init(audioSampleService: AudioSampleService) {
        self.audioSampleService = audioSampleService
    }

    // MARK: - Public functions

    func add(sample: Sample) {
        let model = LayersListCellModel(id: UUID(), sample: sample, isPlaying: false, isMuted: false)
        models.append(model)
    }

    func stop() {
        stopPlayingLayers()
    }

    func getSamplesForRecording() -> [Sample] {
        let models = models.filter { !$0.isMuted }
        return models.map { $0.sample }
    }

    // MARK: - Private functions

    private func playLayer(model: LayersListCellModel) {
        userInteractionDidHappen = true
        models = models.map {
            if $0.id == model.id && !model.isPlaying {
                audioSampleService.play(sample: model.sample) { [weak self] in
                    self?.userInteractionDidHappen = false
                    DispatchQueue.main.async {
                        if self?.userInteractionDidHappen == false {
                            self?.stopPlayingLayers()
                        }
                    }
                }
                return LayersListCellModel(id: $0.id, sample: $0.sample, isPlaying: true, isMuted: $0.isMuted)
            }
            return $0
        }
    }

    private func stopPlayingLayers() {
        userInteractionDidHappen = true
        models = models.map {
            if $0.isPlaying {
                audioSampleService.stop(sample: $0.sample)
                return LayersListCellModel(id: $0.id, sample: $0.sample, isPlaying: false, isMuted: $0.isMuted)
            }
            return $0
        }
    }

    private func changeLayerVolume(layerId: UUID, isMuted: Bool) {
        userInteractionDidHappen = true
        models = models.map {
            if $0.id == layerId {
                return LayersListCellModel(id: $0.id, sample: $0.sample, isPlaying: $0.isPlaying, isMuted: isMuted)
            }
            return $0
        }
    }
}

// MARK: - LayersListCellDelegate

extension LayersListViewModel: LayersListCellDelegate {
    func layersListLayerPlayDidTouch(model: LayersListCellModel) {
        stopPlayingLayers()
        playLayer(model: model)
    }
    
    func layersListLayerPauseDidTouch(model: LayersListCellModel) {
        stopPlayingLayers()
    }
    
    func layersListLayerVolumeDidTouch(model: LayersListCellModel) {
        changeLayerVolume(layerId: model.id, isMuted: true)
    }

    func layersListLayerMutedVolumeDidTouch(model: LayersListCellModel) {
        changeLayerVolume(layerId: model.id, isMuted: false)
    }
    
    func layersListLayerDeleteDidTouch(model: LayersListCellModel) {
        if model.isPlaying {
            stopPlayingLayers()
        }
        models.removeAll(where: { $0.id == model.id })
    }
}
