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

    @Published var footerControlsViewModel = FooterControlsViewModel(
        layersControlIsSelected: true,
        playAndPauseIsSelected: false
    )

    let instruments = instrumentsData
    let layersListViewModel = LayersListViewModel(audioSampleService: AudioSampleService())
    private let audioService = AudioService()

    // MARK: - Initialization

    init() {}

    // MARK: - Public functions

    func viewDidLoad() {
        audioService.configureAudioSession()
    }
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
        footerControlsViewModel = FooterControlsViewModel(
            layersControlIsSelected: isSelected,
            playAndPauseIsSelected: false
        )

        audioService.stopPlaying()
    }

    func footerControlsMicrphoneDidTouch() {}

    func footerControlsRecordDidTouch() {
        footerControlsViewModel = FooterControlsViewModel(
            layersControlIsSelected: false,
            playAndPauseIsSelected: footerControlsViewModel.playAndPauseIsSelected
        )

        layersListViewModel.stop()
        audioService.record()
    }

    func footerControlsStopRecordingDidTouch() {
        audioService.stopRecording()
    }

    func footerControlsPlayDidTouch() {
        footerControlsViewModel = FooterControlsViewModel(
            layersControlIsSelected: false,
            playAndPauseIsSelected: true
        )

        let samples = layersListViewModel.getSamplesForRecording()
        audioService.play(samples: samples) { [weak self] in
            guard let self, footerControlsViewModel.playAndPauseIsSelected else { return }

            footerControlsViewModel = FooterControlsViewModel(
                layersControlIsSelected: footerControlsViewModel.layersControlIsSelected,
                playAndPauseIsSelected: false
            )
        }
    }

    func footerControlsPauseDidTouch() {
        footerControlsViewModel = FooterControlsViewModel(
            layersControlIsSelected: footerControlsViewModel.layersControlIsSelected,
            playAndPauseIsSelected: false
        )

        audioService.stopPlaying()
    }
}

private let instrumentsData = [
    Instrument(title: "гитара", imageName: "guitar", samples: [
        Sample(title: "гитара 1", fileName: "guitar_sample_1", fileExtension: "wav")
    ]),
    Instrument(title: "ударные", imageName: "drums", samples: [
        Sample(title: "ударные 1", fileName: "drums_sample_1", fileExtension: "wav")
    ]),
    Instrument(title: "духовые", imageName: "trumpet", samples: [
        Sample(title: "духовые 1", fileName: "trumpet_sample_1", fileExtension: "wav")
    ])
]
